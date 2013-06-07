Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3FGQup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:50:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44486 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3FGQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:50:41 -0400
Message-ID: <51B20F57.7050100@gmail.com>
Date: Sat, 08 Jun 2013 00:50:31 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2, part3 07/11] PCI, xen-pcifront: use new PCI interfaces
 to simplify implementation
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com> <1368719459-24800-8-git-send-email-jiang.liu@huawei.com> <20130607145024.GA16631@phenom.dumpdata.com> <20130607153822.GA24882@phenom.dumpdata.com>
In-Reply-To: <20130607153822.GA24882@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 11:38 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 07, 2013 at 10:50:24AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Thu, May 16, 2013 at 11:50:55PM +0800, Jiang Liu wrote:
>>> Use new PCI interfaces to simplify xen-pcifront implementation:
>>> 1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
>>>    because pci_scan_bus_parented() is marked as __deprecated.This
>>>    also gets rid of a duplicated call of pci_bus_start_devices().
>>> 2) Use pci_stop_root_bus() and pci_remove_root_bus() instead of
>>>    open-coded private implementation.
>>> 3) Use pci_set_host_bridge_release() to release data structures
>>>    associated with PCI root buses.
>>> 4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
>>>    count.
>>>
>>> This is also a preparation for coming PCI bus lock enhancement.
> 
> With this patch from :
> 
>  Merge branch 'pci_lock_v3' of https://github.com/jiangliu/linux into testing
> 
> 
> it blows up when detaching the device.
Hi Konrad,
   Thanks for testing! According to the log messages, this issue should
be related to pci bus reference counter management. Seems we have done
an extra(unbalanced) release of pci bus device.
   Will investigate it tomorrow!
Regards!
Gerry

> 
> Parsing config from /vm-pv-discard.cfg
> Daemon running with PID 4062
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.10.0-rc4upstream-00172-g909fe9e-dirty (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #2 SMP Fri Jun 7 10:55:54 EDT 2013
> [    0.000000] Command line: console=hvc0 debug 
> [    0.000000] ACPI in unprivileged domain disabled
> [    0.000000] Freeing 20000-40000 pfn range: 131072 pages freed
> [    0.000000] 1-1 mapping on 20000->100000
> [    0.000000] Released 131072 pages of unused memory
> [    0.000000] Set 917504 page(s) to 1-1 mapping
> [    0.000000] Populating 100000-120000 pfn range: 131072 pages added
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
> [    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] Xen: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] Xen: [mem 0x0000000020200000-0x000000003fffffff] unusable
> [    0.000000] Xen: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] Xen: [mem 0x0000000040200000-0x00000000c6cd3fff] unusable
> [    0.000000] Xen: [mem 0x00000000c6cd4000-0x00000000c6d1cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d1d000-0x00000000c6d27fff] ACPI data
> [    0.000000] Xen: [mem 0x00000000c6d28000-0x00000000c6d28fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d29000-0x00000000c6d49fff] reserved
> [    0.000000] Xen: [mem 0x00000000c6d4a000-0x00000000c6d4bfff] unusable
> [    0.000000] Xen: [mem 0x00000000c6d4c000-0x00000000c6d6cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d6d000-0x00000000c6d8ffff] reserved
> [    0.000000] Xen: [mem 0x00000000c6d90000-0x00000000c6d9cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d9d000-0x00000000c6d9ffff] reserved
> [    0.000000] Xen: [mem 0x00000000c6da0000-0x00000000c6db0fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6db1000-0x00000000c6ddcfff] reserved
> [    0.000000] Xen: [mem 0x00000000c6ddd000-0x00000000c6e1ffff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6e20000-0x00000000c6ffffff] unusable
> [    0.000000] Xen: [mem 0x00000000c7800000-0x00000000cf9fffff] reserved
> [    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] Xen: [mem 0x0000000100000000-0x000000011fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI not present or invalid.
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
> [    0.000000] e820: last_pfn = 0x20000 max_arch_pfn = 0x400000000
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
> [    0.000000]  [mem 0x11fe00000-0x11fffffff] page 4k
> [    0.000000] BRK [0x01d8a000, 0x01d8afff] PGTABLE
> [    0.000000] BRK [0x01d8b000, 0x01d8bfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
> [    0.000000]  [mem 0x11c000000-0x11fdfffff] page 4k
> [    0.000000] BRK [0x01d8c000, 0x01d8cfff] PGTABLE
> [    0.000000] BRK [0x01d8d000, 0x01d8dfff] PGTABLE
> [    0.000000] BRK [0x01d8e000, 0x01d8efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
> [    0.000000]  [mem 0x100000000-0x11bffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
> [    0.000000] RAMDISK: [mem 0x02197000-0x13f67fff]
> [    0.000000] NUMA turned off
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
> [    0.000000]   NODE_DATA [mem 0x11fea2000-0x11fea5fff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
> [    0.000000] On node 0 totalpages: 262047
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3999 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1736 pages used for memmap
> [    0.000000]   DMA32 zone: 126976 pages, LIFO batch:31
> [    0.000000]   Normal zone: 1792 pages used for memmap
> [    0.000000]   Normal zone: 131072 pages, LIFO batch:31
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] No local APIC present
> [    0.000000] APIC: disable apic facility
> [    0.000000] APIC: switched to apic NOOP
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000020200000 - 0000000040000000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 0000000040200000 - 00000000c6cd4000
> [    0.000000] PM: Registered nosave memory: 00000000c6cd4000 - 00000000c6d1d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d1d000 - 00000000c6d28000
> [    0.000000] PM: Registered nosave memory: 00000000c6d28000 - 00000000c6d29000
> [    0.000000] PM: Registered nosave memory: 00000000c6d29000 - 00000000c6d4a000
> [    0.000000] PM: Registered nosave memory: 00000000c6d4a000 - 00000000c6d4c000
> [    0.000000] PM: Registered nosave memory: 00000000c6d4c000 - 00000000c6d6d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d6d000 - 00000000c6d90000
> [    0.000000] PM: Registered nosave memory: 00000000c6d90000 - 00000000c6d9d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d9d000 - 00000000c6da0000
> [    0.000000] PM: Registered nosave memory: 00000000c6da0000 - 00000000c6db1000
> [    0.000000] PM: Registered nosave memory: 00000000c6db1000 - 00000000c6ddd000
> [    0.000000] PM: Registered nosave memory: 00000000c6ddd000 - 00000000c6e20000
> [    0.000000] PM: Registered nosave memory: 00000000c6e20000 - 00000000c7000000
> [    0.000000] PM: Registered nosave memory: 00000000c7000000 - 00000000c7800000
> [    0.000000] PM: Registered nosave memory: 00000000c7800000 - 00000000cfa00000
> [    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed40000
> [    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] e820: [mem 0xcfa00000-0xfed1bfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on Xen
> [    0.000000] Xen version: 4.3-unstable (preserve-AD)
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011f800000 s85632 r8192 d20864 u1048576
> [    0.000000] pcpu-alloc: s85632 r8192 d20864 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258442
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: console=hvc0 debug 
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 722480k/4718592k available (6698k kernel code, 3670404k absent, 325708k reserved, 4234k data, 1724k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
> [    0.000000] NR_IRQS:33024 nr_irqs:288 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [hvc0] enabled
> [    0.000000] Xen: using vcpuop timer interface
> [    0.000000] installing Xen timer for CPU 0
> [    0.000000] tsc: Detected 3092.926 MHz processor
> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6185.85 BogoMIPS (lpj=3092926)
> [    0.001000] pid_max: default: 32768 minimum: 301
> [    0.001000] Security Framework initialized
> [    0.001000] SELinux:  Initializing.
> [    0.001000] SELinux:  Starting in permissive mode
> [    0.001000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.001000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.001000] Mount-cache hash table entries: 256
> [    0.001582] Initializing cgroup subsys freezer
> [    0.001698] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.001698] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.001708] CPU: Physical Processor ID: 0
> [    0.001712] CPU: Processor Core ID: 0
> [    0.001718] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.001718] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.001718] tlb_flushall_shift: 5
> [    0.025468] cpu 0 spinlock event irq 17
> [    0.025566] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> [    0.026081] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.026680] installing Xen timer for CPU 1
> [    0.026723] cpu 1 spinlock event irq 24
> [    0.026793] SMP alternatives: switching to SMP code
> [    0.048014] Brought up 2 CPUs
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6cd4000-0xc6d1cfff] (299008 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d28000-0xc6d28fff] (4096 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d4c000-0xc6d6cfff] (135168 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d90000-0xc6d9cfff] (53248 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6da0000-0xc6db0fff] (69632 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6ddd000-0xc6e1ffff] (274432 bytes)
> [    0.051399] kworker/u4:0 (19) used greatest stack depth: 6016 bytes left
> [    0.052492] Grant tables using version 2 layout.
> [    0.052492] Grant table initialized
> [    0.071696] RTC time: 165:165:165, date: 165/165/65
> [    0.071985] NET: Registered protocol family 16
> [    0.072173] kworker/u4:0 (22) used greatest stack depth: 5928 bytes left
> [    0.073110] kworker/u4:0 (30) used greatest stack depth: 5464 bytes left
> [    0.074030] dca service started, version 1.12.1
> [    0.074563] PCI: setting up Xen PCI frontend stub
> [    0.074568] PCI: pci_cache_line_size set to 64 bytes
> [    0.101148] bio: create slab <bio-0> at 0
> [    0.101220] ACPI: Interpreter disabled.
> [    0.102003] xen/balloon: Initialising balloon driver.
> [    0.103081] xen-balloon: Initialising balloon driver.
> [    0.104136] vgaarb: loaded
> [    0.105135] usbcore: registered new interface driver usbfs
> [    0.105135] usbcore: registered new interface driver hub
> [    0.105135] usbcore: registered new device driver usb
> [    0.106089] pps_core: LinuxPPS API ver. 1 registered
> [    0.106089] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.106089] PTP clock support registered
> [    0.106089] PCI: System does not support PCI
> [    0.106089] PCI: System does not support PCI
> [    0.107154] NetLabel: Initializing
> [    0.107154] NetLabel:  domain hash size = 128
> [    0.107154] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.107175] NetLabel:  unlabeled traffic allowed by default
> [    0.108087] Switching to clocksource xen
> [    0.125349] pnp: PnP ACPI: disabled
> [    0.138965] NET: Registered protocol family 2
> [    0.139578] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
> [    0.139647] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
> [    0.139668] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.193672] TCP: reno registered
> [    0.193693] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.193712] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.194030] NET: Registered protocol family 1
> [    0.194380] RPC: Registered named UNIX socket transport module.
> [    0.194389] RPC: Registered udp transport module.
> [    0.194394] RPC: Registered tcp transport module.
> [    0.194398] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.194404] PCI: CLS 0 bytes, default 64
> [    0.194570] Unpacking initramfs...
> [    0.778545] Freeing initrd memory: 292676k freed
> [    0.823501] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.823855] Machine check injector initialized
> [    0.825040] Scanning for low memory corruption every 60 seconds
> [    0.826072] audit: initializing netlink socket (disabled)
> [    0.826114] type=2000 audit(1370618465.698:1): initialized
> [    0.839204] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.839673] VFS: Disk quotas dquot_6.5.2
> [    0.839760] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.840528] NFS: Registering the id_resolver key type
> [    0.840553] Key type id_resolver registered
> [    0.840558] Key type id_legacy registered
> [    0.840587] NTFS driver 2.1.30 [Flags: R/W].
> [    0.840919] msgmni has been set to 1982
> [    0.841082] SELinux:  Registering netfilter hooks
> [    0.842697] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    0.842706] io scheduler noop registered
> [    0.842710] io scheduler deadline registered
> [    0.842772] io scheduler cfq registered (default)
> [    0.843309] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.846284] intel_idle: does not run on family 6 model 42
> [    0.846299] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    0.847400] pcifront pci-0: Installing PCI frontend
> [    0.847417] Warning: only able to allocate 4 MB for software IO TLB
> [    0.850807] software IO TLB [mem 0x109000000-0x109400000] (4MB) mapped at [ffff880109000000-ffff8801093fffff]
> [    0.851175] pcifront pci-0: Creating PCI Frontend Bus 0000:00
> [    0.851458] pcifront pci-0: PCI host bridge to bus 0000:00
> [    0.851469] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    0.851478] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
> [    0.851487] pci_bus 0000:00: root bus resource [bus 00]
> [    0.852031] pci 0000:00:00.0: [8086:105e] type 00 class 0x020000
> [    0.852419] pci 0000:00:00.0: reg 0x10: [mem 0xfe4a0000-0xfe4bffff]
> [    0.852631] pci 0000:00:00.0: reg 0x14: [mem 0xfe480000-0xfe49ffff]
> [    0.852743] pci 0000:00:00.0: reg 0x18: [io  0xe020-0xe03f]
> [    0.853905] pcifront pci-0: New device on 0000:00:00.0 found.
> [    0.857483] pcifront pci-0: claiming resource 0000:00:00.0/0
> [    0.857490] pcifront pci-0: claiming resource 0000:00:00.0/1
> [    0.857495] pcifront pci-0: claiming resource 0000:00:00.0/2
> [    0.939621] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.942227] Non-volatile memory driver v1.3
> [    0.942414] Linux agpgart interface v0.103
> [    0.943295] [drm] Initialized drm 1.1.0 20060810
> [    0.947952] loop: module loaded
> [    0.948577] libphy: Fixed MDIO Bus: probed
> [    0.948583] tun: Universal TUN/TAP device driver, 1.6
> [    0.948588] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.948913] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
> [    0.948921] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    0.950031] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.950039] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> [    0.950061] ehci-pci: EHCI PCI platform driver
> [    0.950201] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.950207] ohci_hcd: block sizes: ed 80 td 96
> [    0.950357] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.950736] usbcore: registered new interface driver usblp
> [    0.951285] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    1.960646] i8042: No controller found
> [    1.960872] mousedev: PS/2 mouse device common for all mice
> [    2.021775] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    2.021941] rtc_cmos: probe of rtc_cmos failed with error -38
> [    2.023233] zram: Created 1 device(s) ...
> [    2.023567] Netfilter messages via NETLINK v0.30.
> [    2.023612] nf_conntrack version 0.5.0 (7930 buckets, 31720 max)
> [    2.023775] ctnetlink v0.93: registering with nfnetlink.
> [    2.024045] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    2.024170] TCP: cubic registered
> [    2.024177] Initializing XFRM netlink socket
> [    2.024379] NET: Registered protocol family 10
> [    2.024936] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    2.025259] sit: IPv6 over IPv4 tunneling driver
> [    2.026039] NET: Registered protocol family 17
> [    2.026320] Key type dns_resolver registered
> [    2.026874] PM: Hibernation image not present or could not be loaded.
> [    2.026922] registered taskstats version 1
> [    2.027005] kmemleak: Kernel memory leak detector initialized
> [    2.027009] kmemleak: Automatic memory scanning thread started
> [    2.027437] XENBUS: Device with no driver: device/vbd/51712
> [    2.027537]   Magic number: 1:252:3141
> [    2.029169] Freeing unused kernel memory: 1724k freed
> [    2.029408] Write protecting the kernel read-only data: 10240k
> [    2.033649] Freeing unused kernel memory: 1480k freed
> [    2.033908] Freeing unused kernel memory: 72k freed
> 
> init started: BusyBox v1.14.3 (2013-06-07 10:58:39 EDT)
> [    2.040621] consoletype (1038) used greatest stack depth: 5304 bytes left
> Mounting directories  [  OK  ]
> [    2.059689] chmod (1044) used greatest stack depth: 4856 bytes left
> mount: mount point /proc/bus/usb does not exist
> mount: mount point /sys/kernel/config does not exist
> [    2.266374] Initialising Xen virtual ethernet driver.
> [    2.273190] vbd vbd-51712: blkfront:blkback_changed to state 2.
> [    2.283349] vbd vbd-51712: blkfront:blkback_changed to state 4.
> [    2.283356] vbd vbd-51712: blkfront_connect:/local/domain/0/backend/vbd/2/51712.
> [    2.287707] blkfront: xvda: flush diskcache: enabled; persistent grants: enabled; indirect descriptors: enabled;
> [    2.288337] Entered do_blkif_request
> [    2.288344] Entered do_blkif_request
> [    2.288821] Entered do_blkif_request
> [    2.288829] do_blk_req ffff880108ec9e10: cmd ffff880108ec9f00, sec 0, (4/4) buffer:ffff880108ee6000 [read]
> [    2.288839] Entered do_blkif_request
> [    2.288859] Entered do_blkif_request
> [    2.288864] do_blk_req ffff880108ec9cb8: cmd ffff880108ec9da8, sec 4, (4/4) buffer:ffff880108ee6800 [read]
> [    2.288871] Entered do_blkif_request
> [    2.292721] Entered do_blkif_request
> [    2.292727] Entered do_blkif_request
> [    2.292737] Entered do_blkif_request
> [    2.292741] Entered do_blkif_request
> [    2.292780] Entered do_blkif_request
> [    2.292786] do_blk_req ffff880108ec9cb8: cmd ffff880108ec9da8, sec 8, (4/4) buffer:ffff88010f273000 [read]
> [    2.292794] Entered do_blkif_request
> [    2.292811] Entered do_blkif_request
> [    2.292816] do_blk_req ffff880108ec9e10: cmd ffff880108ec9f00, sec c, (4/4) buffer:ffff88010f273800 [read]
> [    2.292822] Entered do_blkif_request
> [    2.292940] Entered do_blkif_request
> [    2.292947] Entered do_blkif_request
> [    2.292957] Entered do_blkif_request
> [    2.292961] Entered do_blkif_request
> [    2.292974]  xvda: unknown partition table
> [    2.385804] udevd (1099): /proc/1099/oom_adj is deprecated, please use /proc/1099/oom_score_adj instead.
> [    2.444038] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    2.444061] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    2.444110] e1000e 0000:00:00.0: Disabling ASPM  L1
> [    2.444232] e1000e 0000:00:00.0: enabling device (0000 -> 0002)
> [    2.447244] e1000e 0000:00:00.0: Xen PCI mapped GSI16 to IRQ34
> [    2.447790] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> udevd-work[1106]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory
> 
> [    2.459644] vbd vbd-51712: command: 0x5331, argument: 0x0
> [    2.560213] ip (1325) used greatest stack depth: 3760 bytes left
> [    2.624581] e1000e 0000:00:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a2
> [    2.624595] e1000e 0000:00:00.0 eth0: Intel(R) PRO/1000 Network Connection
> [    2.624675] e1000e 0000:00:00.0 eth0: MAC: 0, PHY: 4, PBA No: D50868-003
> Waiting for devices [  OK  ]
> Waiting for fb [  OK  ]
> Starting..[/dev/fb0]
> Could not open; err: 2
> FATAL: Module agpgart_intel not found.
> [    2.814571] [drm] radeon kernel modesetting enabled.
> WARNING: Error inserting video (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/acpi/video.ko): No such device
> WARNING: Error inserting mxm_wmi (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/platform/x86/mxm-wmi.ko): No such device
> WARNING: Error inserting drm_kms_helper (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
> WARNING: Error inserting ttm (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/gpu/drm/ttm/ttm.ko): No such device
> FATAL: Error inserting nouveau (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/gpu/drm/nouveau/nouveau.ko): No such device
> WARNING: Error inserting drm_kms_helper (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/gpu/drm/drm_kms_helper.ko): No such device
> FATAL: Error inserting i915 (/lib/modules/3.10.0-rc4upstream-00172-g909fe9e-dirty/kernel/drivers/gpu/drm/i915/i915.ko): No such device
> Starting..[/dev/fb0]
> Could not open; err: 2
> VGA: 0000:
> Waiting for network [  OK  ]
> Bringing up loopback interface:  [  OK  ]
> Bringing up interface eth0:  [    3.394987] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    3.397647] device eth0 entered promiscuous mode
> [  OK  ]
> Bringing up interface switch:  
> Determining IP information for switch...[    3.452997] IPv6: ADDRCONF(NETDEV_UP): switch: link is not ready
> [    5.533965] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [    5.534117] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    5.534222] switch: port 1(eth0) entered forwarding state
> [    5.534239] switch: port 1(eth0) entered forwarding state
> [    5.534302] IPv6: ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
>  done.
> [  OK  ]
> Waiting for init.custom [  OK  ]
> 
> Starting SSHd ...
> 
>     SSH started [2202]
> 
> 
> Waiting for SSHd [  OK  ]
> WARNING: ssh currently running [2202] ignoring start request
> FATAL: Module dump_dma not found.
> ERROR: Module dump_dma does not exist in /proc/modules
> [    9.129856] SCSI subsystem initialized
> [    9.131318] Loading iSCSI transport class v2.0-870.
> [    9.134894] iscsi: registered transport (tcp)
> hostname: Name or service not known
> iscsistart: transport class version 2.0-870. iscsid version 2.0-872
> Could not get list of targets from firmware.
> Jun  7 15:21:14 (none) syslogd 1.5.0: restart.
> Running in PV context on Xen v4.3.
> FATAL: Module evtchn not found.
> [    9.176036] Event-channel device installed.
> 00:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>            CPU0       CPU1       
>  16:       2600          0  xen-percpu-virq      timer0
>  17:          0          0  xen-percpu-ipi       spinlock0
>  18:       3473          0  xen-percpu-ipi       resched0
>  19:          0          0  xen-percpu-ipi       callfunc0
>  20:          0          0  xen-percpu-virq      debug0
>  21:        237          0  xen-percpu-ipi       callfuncsingle0
>  22:          0          0  xen-percpu-ipi       irqwork0
>  23:          0       2560  xen-percpu-virq      timer1
>  24:          0          0  xen-percpu-ipi       spinlock1
>  25:          0       3833  xen-percpu-ipi       resched1
>  26:          0          0  xen-percpu-ipi       callfunc1
>  27:          0          0  xen-percpu-virq      debug1
>  28:          0        271  xen-percpu-ipi       callfuncsingle1
>  29:          0          0  xen-percpu-ipi       irqwork1
>  30:        235          0   xen-dyn-event     xenbus
>  31:         64          0   xen-dyn-event     pcifront
>  32:         89          0   xen-dyn-event     hvc_console
>  33:          4          0   xen-dyn-event     blkif
>  35:         27          0  xen-pirq-pcifront-msi  eth0
> NMI:          0          0   Non-maskable interrupts
> LOC:          0          0   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> PMI:          0          0   Performance monitoring interrupts
> IWI:          0          0   IRQ work interrupts
> RTR:          0          0   APIC ICR read retries
> RES:       3473       3833   Rescheduling interrupts
> CAL:        237        271   Function call interrupts
> TLB:          0          0   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> MCE:          0          0   Machine check exceptions
> MCP:          0          0   Machine check polls
> ERR:          0
> MIS:          0
> 00000000-00000fff : reserved
> 00001000-0009ffff : System RAM
> 000a0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-1fffffff : System RAM
>   01000000-0168a927 : Kernel code
>   0168a928-01aad2bf : Kernel data
>   01c65000-01d74fff : Kernel bss
> 20200000-3fffffff : Unusable memory
> 40200000-c6cd3fff : Unusable memory
> c6cd4000-c6d1cfff : ACPI Non-volatile Storage
> c6d1d000-c6d27fff : ACPI Tables
> c6d28000-c6d28fff : ACPI Non-volatile Storage
> c6d4a000-c6d4bfff : Unusable memory
> c6d4c000-c6d6cfff : ACPI Non-volatile Storage
> c6d90000-c6d9cfff : ACPI Non-volatile Storage
> c6da0000-c6db0fff : ACPI Non-volatile Storage
> c6ddd000-c6e1ffff : ACPI Non-volatile Storage
> c6e20000-c6ffffff : Unusable memory
> fe480000-fe49ffff : 0000:00:00.0
>   fe480000-fe49ffff : e1000e
> fe4a0000-fe4bffff : 0000:00:00.0
>   fe4a0000-fe4bffff : e1000e
> 100000000-11fffffff : System RAM
> MemTotal:        1018432 kB
> MemFree:          641536 kB
> Buffers:               0 kB
> Cached:           310180 kB
> SwapCached:            0 kB
> Active:            19368 kB
> Inactive:         290652 kB
> Active(anon):      13120 kB
> Inactive(anon):    84540 kB
> Active(file):       6248 kB
> Inactive(file):   206112 kB
> Unevictable:        4940 kB
> Mlocked:            4940 kB
> SwapTotal:             0 kB
> SwapFree:              0 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:          4684 kB
> Mapped:             5152 kB
> Shmem:             94284 kB
> Slab:              45924 kB
> SReclaimable:      12804 kB
> SUnreclaim:        33120 kB
> KernelStack:         432 kB
> PageTables:          692 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:      509216 kB
> Committed_AS:     102792 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:        2332 kB
> VmallocChunk:   34359735931 kB
> AnonHugePages:         0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:     1048576 kB
> DirectMap2M:           0 kB
> Waiting for init.late [  OK  ]
> PING build.dumpdata.com (192.168.102.1) 56(84) bytes of data.
> 
> --- build.dumpdata.com ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.208/0.208/0.208/0.000 ms
> [    9.336320] mount.nfs (2304) used greatest stack depth: 3320 bytes left
> mount.nfs: access denied by server while mounting build:/srv/results
> NFS done
> /init.late: line 13: can't create /mnt/results/dmesg/(none)-3.10.0-rc4upstream-00172-g909fe9e-dirty.dmesg: nonexistent directory
>  [0x0->0x20000] pfn
>  [0x0->0x20000] level entry
>  [0x20000->0x100000] identity
>  [0x20000->0x100000] level middle
>  [0x100000->0x120000] pfn
>  [0x100000->0x120000] level entry
>  [0x120000->0x140000] level middle
>  [0x120000->0x7cfffff] missing
>  [0x140000->0x7cfffff] level top
> /init.late: line 17: can't create /mnt/results/p2m/(none)-3.10.0-rc4upstream-00172-g909fe9e-dirty.p2m: nonexistent directory
> libxl: error: libxl.c:87:libxl_ctx_alloc: Is xenstore daemon running?
> failed to stat /var/run/xenstored.pid: No such file or directory
> cannot init xl context
> [    9.669091] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [    9.670252] device-mapper: multipath: version 1.5.1 loaded
> PING 192.168.101.2 (192.168.101.2) 56(84) bytes of data.
> kill -1 1
> 
> --- 192.168.101.2 ping statistics ---
> 1 packets transmitted, 0 received, 100% packet loss, time 10000ms
> 
> /init.late: line 34: boot_parameter: not found
> [   20.576092] switch: port 1(eth0) entered forwarding state
>  7 Jun 15:21:27 ntpdate[2323]: adjust time server 17.171.4.15 offset -0.265117 sec
> Cannot access the Hardware Clock via any known method.
> Use the --debug option to see the details of our search for an access method.
> Fri Jun  7 15:21:27 UTC 2013
> Jun  7 15:21:27 (none) init: starting pid 2333, tty '/dev/tty0': '/bin/sh'
> Jun  7 15:21:27 (none) init: starting pid 2334, tty '/dev/tty1': '/bin/sh'
> Jun  7 15:21:27 (none) init: starting pid 2335, tty '/dev/ttyS0': '/bin/sh'
> Jun  7 15:21:27 (none) init: starting pid 2336, tty '/dev/hvc0': '/bin/sh'
> 
> 
> BusyBox v1.14.3 (2013-06-07 10:58:39 EDT) built-in shell (ash)
> Enter 'help' for a list of built-in commands.
> 
> # kill -1 1
> # Jun  7 15:21:27 (none) init: reloading /etc/inittab
> 
> # m dmesg
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.10.0-rc4upstream-00172-g909fe9e-dirty (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #2 SMP Fri Jun 7 10:55:54 EDT 2013
> [    0.000000] Command line: console=hvc0 debug 
> [    0.000000] ACPI in unprivileged domain disabled
> [    0.000000] Freeing 20000-40000 pfn range: 131072 pages freed
> [    0.000000] 1-1 mapping on 20000->100000
> [    0.000000] Released 131072 pages of unused memory
> [    0.000000] Set 917504 page(s) to 1-1 mapping
> [    0.000000] Populating 100000-120000 pfn range: 131072 pages added
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
> [    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] Xen: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] Xen: [mem 0x0000000020200000-0x000000003fffffff] unusable
> [    0.000000] Xen: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] Xen: [mem 0x0000000040200000-0x00000000c6cd3fff] unusable
> [    0.000000] Xen: [mem 0x00000000c6cd4000-0x00000000c6d1cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d1d000-0x00000000c6d27fff] ACPI data
> [    0.000000] Xen: [mem 0x00000000c6d28000-0x00000000c6d28fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d29000-0x00000000c6d49fff] reserved
> [    0.000000] Xen: [mem 0x00000000c6d4a000-0x00000000c6d4bfff] unusable
> [    0.000000] Xen: [mem 0x00000000c6d4c000-0x00000000c6d6cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d6d000-0x00000000c6d8ffff] reserved
> [    0.000000] Xen: [mem 0x00000000c6d90000-0x00000000c6d9cfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6d9d000-0x00000000c6d9ffff] reserved
> [    0.000000] Xen: [mem 0x00000000c6da0000-0x00000000c6db0fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6db1000-0x00000000c6ddcfff] reserved
> [    0.000000] Xen: [mem 0x00000000c6ddd000-0x00000000c6e1ffff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000c6e20000-0x00000000c6ffffff] unusable
> [    0.000000] Xen: [mem 0x00000000c7800000-0x00000000cf9fffff] reserved
> [    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] Xen: [mem 0x0000000100000000-0x000000011fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI not present or invalid.
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
> [    0.000000] e820: last_pfn = 0x20000 max_arch_pfn = 0x400000000
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
> [    0.000000]  [mem 0x11fe00000-0x11fffffff] page 4k
> [    0.000000] BRK [0x01d8a000, 0x01d8afff] PGTABLE
> [    0.000000] BRK [0x01d8b000, 0x01d8bfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
> [    0.000000]  [mem 0x11c000000-0x11fdfffff] page 4k
> [    0.000000] BRK [0x01d8c000, 0x01d8cfff] PGTABLE
> [    0.000000] BRK [0x01d8d000, 0x01d8dfff] PGTABLE
> [    0.000000] BRK [0x01d8e000, 0x01d8efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
> [    0.000000]  [mem 0x100000000-0x11bffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
> [    0.000000] RAMDISK: [mem 0x02197000-0x13f67fff]
> [    0.000000] NUMA turned off
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
> [    0.000000]   NODE_DATA [mem 0x11fea2000-0x11fea5fff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
> [    0.000000] On node 0 totalpages: 262047
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3999 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1736 pages used for memmap
> [    0.000000]   DMA32 zone: 126976 pages, LIFO batch:31
> [    0.000000]   Normal zone: 1792 pages used for memmap
> [    0.000000]   Normal zone: 131072 pages, LIFO batch:31
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] No local APIC present
> [    0.000000] APIC: disable apic facility
> [    0.000000] APIC: switched to apic NOOP
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000020200000 - 0000000040000000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 0000000040200000 - 00000000c6cd4000
> [    0.000000] PM: Registered nosave memory: 00000000c6cd4000 - 00000000c6d1d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d1d000 - 00000000c6d28000
> [    0.000000] PM: Registered nosave memory: 00000000c6d28000 - 00000000c6d29000
> [    0.000000] PM: Registered nosave memory: 00000000c6d29000 - 00000000c6d4a000
> [    0.000000] PM: Registered nosave memory: 00000000c6d4a000 - 00000000c6d4c000
> [    0.000000] PM: Registered nosave memory: 00000000c6d4c000 - 00000000c6d6d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d6d000 - 00000000c6d90000
> [    0.000000] PM: Registered nosave memory: 00000000c6d90000 - 00000000c6d9d000
> [    0.000000] PM: Registered nosave memory: 00000000c6d9d000 - 00000000c6da0000
> [    0.000000] PM: Registered nosave memory: 00000000c6da0000 - 00000000c6db1000
> [    0.000000] PM: Registered nosave memory: 00000000c6db1000 - 00000000c6ddd000
> [    0.000000] PM: Registered nosave memory: 00000000c6ddd000 - 00000000c6e20000
> [    0.000000] PM: Registered nosave memory: 00000000c6e20000 - 00000000c7000000
> [    0.000000] PM: Registered nosave memory: 00000000c7000000 - 00000000c7800000
> [    0.000000] PM: Registered nosave memory: 00000000c7800000 - 00000000cfa00000
> [    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed40000
> [    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] e820: [mem 0xcfa00000-0xfed1bfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on Xen
> [    0.000000] Xen version: 4.3-unstable (preserve-AD)
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011f800000 s85632 r8192 d20864 u1048576
> [    0.000000] pcpu-alloc: s85632 r8192 d20864 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258442
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: console=hvc0 debug 
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 722480k/4718592k available (6698k kernel code, 3670404k absent, 325708k reserved, 4234k data, 1724k init)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
> [    0.000000] NR_IRQS:33024 nr_irqs:288 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [hvc0] enabled
> [    0.000000] Xen: using vcpuop timer interface
> [    0.000000] installing Xen timer for CPU 0
> [    0.000000] tsc: Detected 3092.926 MHz processor
> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6185.85 BogoMIPS (lpj=3092926)
> [    0.001000] pid_max: default: 32768 minimum: 301
> [    0.001000] Security Framework initialized
> [    0.001000] SELinux:  Initializing.
> [    0.001000] SELinux:  Starting in permissive mode
> [    0.001000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.001000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.001000] Mount-cache hash table entries: 256
> [    0.001582] Initializing cgroup subsys freezer
> [    0.001698] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.001698] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.001708] CPU: Physical Processor ID: 0
> [    0.001712] CPU: Processor Core ID: 0
> [    0.001718] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.001718] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.001718] tlb_flushall_shift: 5
> [    0.025468] cpu 0 spinlock event irq 17
> [    0.025566] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> [    0.026081] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.026680] installing Xen timer for CPU 1
> [    0.026723] cpu 1 spinlock event irq 24
> [    0.026793] SMP alternatives: switching to SMP code
> [    0.048014] Brought up 2 CPUs
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6cd4000-0xc6d1cfff] (299008 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d28000-0xc6d28fff] (4096 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d4c000-0xc6d6cfff] (135168 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6d90000-0xc6d9cfff] (53248 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6da0000-0xc6db0fff] (69632 bytes)
> [    0.051334] PM: Registering ACPI NVS region [mem 0xc6ddd000-0xc6e1ffff] (274432 bytes)
> [    0.051399] kworker/u4:0 (19) used greatest stack depth: 6016 bytes left
> [    0.052492] Grant tables using version 2 layout.
> [    0.052492] Grant table initialized
> [    0.071696] RTC time: 165:165:165, date: 165/165/65
> [    0.071985] NET: Registered protocol family 16
> [    0.072173] kworker/u4:0 (22) used greatest stack depth: 5928 bytes left
> [    0.073110] kworker/u4:0 (30) used greatest stack depth: 5464 bytes left
> [    0.074030] dca service started, version 1.12.1
> [    0.074563] PCI: setting up Xen PCI frontend stub
> [    0.074568] PCI: pci_cache_line_size set to 64 bytes
> [    0.101148] bio: create slab <bio-0> at 0
> [    0.101220] ACPI: Interpreter disabled.
> [    0.102003] xen/balloon: Initialising balloon driver.
> [    0.103081] xen-balloon: Initialising balloon driver.
> [    0.104136] vgaarb: loaded
> [    0.105135] usbcore: registered new interface driver usbfs
> [    0.105135] usbcore: registered new interface driver hub
> [    0.105135] usbcore: registered new device driver usb
> [    0.106089] pps_core: LinuxPPS API ver. 1 registered
> [    0.106089] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.106089] PTP clock support registered
> [    0.106089] PCI: System does not support PCI
> [    0.106089] PCI: System does not support PCI
> [    0.107154] NetLabel: Initializing
> [    0.107154] NetLabel:  domain hash size = 128
> [    0.107154] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.107175] NetLabel:  unlabeled traffic allowed by default
> [    0.108087] Switching to clocksource xen
> [    0.125349] pnp: PnP ACPI: disabled
> [    0.138965] NET: Registered protocol family 2
> [    0.139578] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
> [    0.139647] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
> [    0.139668] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.193672] TCP: reno registered
> [    0.193693] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.193712] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.194030] NET: Registered protocol family 1
> [    0.194380] RPC: Registered named UNIX socket transport module.
> [    0.194389] RPC: Registered udp transport module.
> [    0.194394] RPC: Registered tcp transport module.
> [    0.194398] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.194404] PCI: CLS 0 bytes, default 64
> [    0.194570] Unpacking initramfs...
> [    0.778545] Freeing initrd memory: 292676k freed
> [    0.823501] platform rtc_cmos: registered platform RTC device (no PNP device found)
> [    0.823855] Machine check injector initialized
> [    0.825040] Scanning for low memory corruption every 60 seconds
> [    0.826072] audit: initializing netlink socket (disabled)
> [    0.826114] type=2000 audit(1370618465.698:1): initialized
> [    0.839204] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.839673] VFS: Disk quotas dquot_6.5.2
> [    0.839760] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.840528] NFS: Registering the id_resolver key type
> [    0.840553] Key type id_resolver registered
> [    0.840558] Key type id_legacy registered
> [    0.840587] NTFS driver 2.1.30 [Flags: R/W].
> [    0.840919] msgmni has been set to 1982
> [    0.841082] SELinux:  Registering netfilter hooks
> [    0.842697] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    0.842706] io scheduler noop registered
> [    0.842710] io scheduler deadline registered
> [    0.842772] io scheduler cfq registered (default)
> [    0.843309] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.846284] intel_idle: does not run on family 6 model 42
> [    0.846299] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    0.847400] pcifront pci-0: Installing PCI frontend
> [    0.847417] Warning: only able to allocate 4 MB for software IO TLB
> [    0.850807] software IO TLB [mem 0x109000000-0x109400000] (4MB) mapped at [ffff880109000000-ffff8801093fffff]
> [    0.851175] pcifront pci-0: Creating PCI Frontend Bus 0000:00
> [    0.851458] pcifront pci-0: PCI host bridge to bus 0000:00
> [    0.851469] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    0.851478] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
> [    0.851487] pci_bus 0000:00: root bus resource [bus 00]
> [    0.852031] pci 0000:00:00.0: [8086:105e] type 00 class 0x020000
> [    0.852419] pci 0000:00:00.0: reg 0x10: [mem 0xfe4a0000-0xfe4bffff]
> [    0.852631] pci 0000:00:00.0: reg 0x14: [mem 0xfe480000-0xfe49ffff]
> [    0.852743] pci 0000:00:00.0: reg 0x18: [io  0xe020-0xe03f]
> [    0.853905] pcifront pci-0: New device on 0000:00:00.0 found.
> [    0.857483] pcifront pci-0: claiming resource 0000:00:00.0/0
> [    0.857490] pcifront pci-0: claiming resource 0000:00:00.0/1
> [    0.857495] pcifront pci-0: claiming resource 0000:00:00.0/2
> [    0.939621] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.942227] Non-volatile memory driver v1.3
> [    0.942414] Linux agpgart interface v0.103
> [    0.943295] [drm] Initialized drm 1.1.0 20060810
> [    0.947952] loop: module loaded
> [    0.948577] libphy: Fixed MDIO Bus: probed
> [    0.948583] tun: Universal TUN/TAP device driver, 1.6
> [    0.948588] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.948913] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.7.12-k
> [    0.948921] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    0.950031] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.950039] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
> [    0.950061] ehci-pci: EHCI PCI platform driver
> [    0.950201] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.950207] ohci_hcd: block sizes: ed 80 td 96
> [    0.950357] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.950736] usbcore: registered new interface driver usblp
> [    0.951285] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    1.960646] i8042: No controller found
> [    1.960872] mousedev: PS/2 mouse device common for all mice
> [    2.021775] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    2.021941] rtc_cmos: probe of rtc_cmos failed with error -38
> [    2.023233] zram: Created 1 device(s) ...
> [    2.023567] Netfilter messages via NETLINK v0.30.
> [    2.023612] nf_conntrack version 0.5.0 (7930 buckets, 31720 max)
> [    2.023775] ctnetlink v0.93: registering with nfnetlink.
> [    2.024045] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    2.024170] TCP: cubic registered
> [    2.024177] Initializing XFRM netlink socket
> [    2.024379] NET: Registered protocol family 10
> [    2.024936] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    2.025259] sit: IPv6 over IPv4 tunneling driver
> [    2.026039] NET: Registered protocol family 17
> [    2.026320] Key type dns_resolver registered
> [    2.026874] PM: Hibernation image not present or could not be loaded.
> [    2.026922] registered taskstats version 1
> [    2.027005] kmemleak: Kernel memory leak detector initialized
> [    2.027009] kmemleak: Automatic memory scanning thread started
> [    2.027437] XENBUS: Device with no driver: device/vbd/51712
> [    2.027537]   Magic number: 1:252:3141
> [    2.029169] Freeing unused kernel memory: 1724k freed
> [    2.029408] Write protecting the kernel read-only data: 10240k
> [    2.033649] Freeing unused kernel memory: 1480k freed
> [    2.033908] Freeing unused kernel memory: 72k freed
> [    2.040621] consoletype (1038) used greatest stack depth: 5304 bytes left
> [    2.059689] chmod (1044) used greatest stack depth: 4856 bytes left
> [    2.266374] Initialising Xen virtual ethernet driver.
> [    2.273190] vbd vbd-51712: blkfront:blkback_changed to state 2.
> [    2.283349] vbd vbd-51712: blkfront:blkback_changed to state 4.
> [    2.283356] vbd vbd-51712: blkfront_connect:/local/domain/0/backend/vbd/2/51712.
> [    2.287707] blkfront: xvda: flush diskcache: enabled; persistent grants: enabled; indirect descriptors: enabled;
> [    2.288337] Entered do_blkif_request
> [    2.288344] Entered do_blkif_request
> [    2.288821] Entered do_blkif_request
> [    2.288829] do_blk_req ffff880108ec9e10: cmd ffff880108ec9f00, sec 0, (4/4) buffer:ffff880108ee6000 [read]
> [    2.288839] Entered do_blkif_request
> [    2.288859] Entered do_blkif_request
> [    2.288864] do_blk_req ffff880108ec9cb8: cmd ffff880108ec9da8, sec 4, (4/4) buffer:ffff880108ee6800 [read]
> [    2.288871] Entered do_blkif_request
> [    2.292721] Entered do_blkif_request
> [    2.292727] Entered do_blkif_request
> [    2.292737] Entered do_blkif_request
> [    2.292741] Entered do_blkif_request
> [    2.292780] Entered do_blkif_request
> [    2.292786] do_blk_req ffff880108ec9cb8: cmd ffff880108ec9da8, sec 8, (4/4) buffer:ffff88010f273000 [read]
> [    2.292794] Entered do_blkif_request
> [    2.292811] Entered do_blkif_request
> [    2.292816] do_blk_req ffff880108ec9e10: cmd ffff880108ec9f00, sec c, (4/4) buffer:ffff88010f273800 [read]
> [    2.292822] Entered do_blkif_request
> [    2.292940] Entered do_blkif_request
> [    2.292947] Entered do_blkif_request
> [    2.292957] Entered do_blkif_request
> [    2.292961] Entered do_blkif_request
> [    2.292974]  xvda: unknown partition table
> [    2.385804] udevd (1099): /proc/1099/oom_adj is deprecated, please use /proc/1099/oom_score_adj instead.
> [    2.444038] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    2.444061] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    2.444110] e1000e 0000:00:00.0: Disabling ASPM  L1
> [    2.444232] e1000e 0000:00:00.0: enabling device (0000 -> 0002)
> [    2.447244] e1000e 0000:00:00.0: Xen PCI mapped GSI16 to IRQ34
> [    2.447790] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    2.459644] vbd vbd-51712: command: 0x5331, argument: 0x0
> [    2.560213] ip (1325) used greatest stack depth: 3760 bytes left
> [    2.624581] e1000e 0000:00:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a2
> [    2.624595] e1000e 0000:00:00.0 eth0: Intel(R) PRO/1000 Network Connection
> [    2.624675] e1000e 0000:00:00.0 eth0: MAC: 0, PHY: 4, PBA No: D50868-003
> [    2.814571] [drm] radeon kernel modesetting enabled.
> [    3.394987] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    3.397647] device eth0 entered promiscuous mode
> [    3.452997] IPv6: ADDRCONF(NETDEV_UP): switch: link is not ready
> [    5.533965] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [    5.534117] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    5.534222] switch: port 1(eth0) entered forwarding state
> [    5.534239] switch: port 1(eth0) entered forwarding state
> [    5.534302] IPv6: ADDRCONF(NETDEV_CHANGE): switch: link becomes ready
> [    9.129856] SCSI subsystem initialized
> [    9.131318] Loading iSCSI transport class v2.0-870.
> [    9.134894] iscsi: registered transport (tcp)
> [    9.176036] Event-channel device installed.
> [    9.336320] mount.nfs (2304) used greatest stack depth: 3320 bytes left
> [    9.669091] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [    9.670252] device-mapper: multipath: version 1.5.1 loaded
> [   20.576092] switch: port 1(eth0) entered forwarding state
> # lspci
> 00:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
> # ifconfig
> eth0      Link encap:Ethernet  HWaddr 00:15:17:8F:18:A2  
>           inet6 addr: fe80::215:17ff:fe8f:18a2/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:116 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:141 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000 
>           RX bytes:12017 (11.7 KiB)  TX bytes:13404 (13.0 KiB)
>           Interrupt:34 Memory:fe4a0000-fe4c0000 
> 
> lo        Link encap:Local Loopback  
>           inet addr:127.0.0.1  Mask:255.0.0.0
>           inet6 addr: ::1/128 Scope:Host
>           UP LOOPBACK RUNNING  MTU:65536  Metric:1
>           RX packets:8 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0 
>           RX bytes:520 (520.0 b)  TX bytes:520 (520.0 b)
> 
> switch    Link encap:Ethernet  HWaddr 00:15:17:8F:18:A2  
>           inet addr:192.168.102.210  Bcast:192.168.102.255  Mask:255.255.255.0
>           inet6 addr: fe80::215:17ff:fe8f:18a2/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:116 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:134 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0 
>           RX bytes:9929 (9.6 KiB)  TX bytes:12244 (11.9 KiB)
> 
> # eth
> # ethtool [J-i eth0
> driver: e1000e
> version: 2.3.2-k
> firmware-version: 5.11-2
> bus-info: 0000:00:00.0
> # rmmod e1000e
> [   39.032406] switch: port 1(eth0) entered disabled state
> [   39.032576] device eth0 left promiscuous mode
> [   39.032583] switch: port 1(eth0) entered disabled state
> # miod   odprobe e1000e
> [   42.614015] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [   42.614026] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [   42.614080] e1000e 0000:00:00.0: Disabling ASPM  L1
> [   42.614172] xen_map_pirq_gsi: returning irq 34 for gsi 16
> [   42.614181] e1000e 0000:00:00.0: Xen PCI mapped GSI16 to IRQ34
> [   42.615024] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [   42.790351] e1000e 0000:00:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:15:17:8f:18:a2
> [   42.790363] e1000e 0000:00:00.0 eth0: Intel(R) PRO/1000 Network Connection
> [   42.790448] e1000e 0000:00:00.0 eth0: MAC: 0, PHY: 4, PBA No: D50868-003
> # [   43.103936] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   43.106574] device eth0 entered promiscuous mode
> rmmod e100[   45.190968] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   45.191117] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   45.191210] switch: port 1(eth0) entered forwarding state
> [   45.191227] switch: port 1(eth0) entered forwarding state
> 0e
> [   46.621376] switch: port 1(eth0) entered disabled state
> [   46.621538] device eth0 left promiscuous mode
> [   46.621547] switch: port 1(eth0) entered disabled state
> # 
> 
> 
> 
> DETACHING HERE..
> 
> # 
> # [   53.802739] pcifront pci-0: Rescanning PCI Frontend Bus 0000:00
> [   53.887894] pci_bus 0000:00: busn_res: [bus 00] is released
> [   53.888042] ------------[ cut here ]------------
> [   53.888055] WARNING: at /home/konrad/linux/include/linux/kref.h:47 klist_iter_init_node+0x3e/0x50()
> [   53.888073] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod libcrc32c crc32c radeon fbcon tileblit font bitblit softcursor ttm drm_kms_helper crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd [last unloaded: e1000e]
> [   53.888151] CPU: 1 PID: 26 Comm: xenwatch Not tainted 3.10.0-rc4upstream-00172-g909fe9e-dirty #2
> [   53.888158]  ffffffff819392b8 ffff88011e3c1b88 ffffffff8167a27d ffff88011e3c1bc8
> [   53.888171]  ffffffff8108d1eb ffff880109536a00 ffff88011e3c1c18 0000000000000000
> [   53.888186]  ffffffff8131c410 0000000000000000 ffff88011e3c1e70 ffff88011e3c1bd8
> [   53.888197] Call Trace:
> [   53.888203]  [<ffffffff8167a27d>] dump_stack+0x19/0x1b
> [   53.888212]  [<ffffffff8108d1eb>] warn_slowpath_common+0x6b/0xa0
> [   53.888220]  [<ffffffff8131c410>] ? pci_match_next_bus+0x10/0x10
> [   53.888227]  [<ffffffff8108d235>] warn_slowpath_null+0x15/0x20
> [   53.888234]  [<ffffffff81663b4e>] klist_iter_init_node+0x3e/0x50
> [   53.888242]  [<ffffffff8142117d>] class_dev_iter_init+0x3d/0x50
> [   53.888248]  [<ffffffff81421348>] class_find_device+0x38/0xb0
> [   53.888255]  [<ffffffff8131c8aa>] pci_get_next_root_bus+0x4a/0x80
> [   53.888262]  [<ffffffff8132f6a5>] pcifront_free_roots+0x25/0x60
> [   53.888268]  [<ffffffff8132f6f1>] free_pdev+0x11/0x80
> [   53.888274]  [<ffffffff8132f77a>] pcifront_xenbus_remove+0x1a/0x20
> [   53.888283]  [<ffffffff813abae8>] xenbus_dev_remove+0x38/0x70
> [   53.888289]  [<ffffffff8141ffc1>] __device_release_driver+0x61/0xd0
> [   53.888296]  [<ffffffff81420148>] device_release_driver+0x28/0x40
> [   53.888302]  [<ffffffff8141f296>] bus_remove_device+0x106/0x140
> [   53.888310]  [<ffffffff8141d120>] device_del+0x110/0x1c0
> [   53.888316]  [<ffffffff8141d1e1>] device_unregister+0x11/0x20
> [   53.888323]  [<ffffffff813ab946>] xenbus_dev_changed+0x96/0x1d0
> [   53.888331]  [<ffffffff81048bd6>] ? xen_spin_lock+0xa6/0x110
> [   53.888338]  [<ffffffff813ad2f6>] frontend_changed+0x16/0x20
> [   53.888345]  [<ffffffff813a9c5b>] xenwatch_thread+0xcb/0x190
> [   53.888352]  [<ffffffff810b49d0>] ? wake_up_bit+0x40/0x40
> [   53.888359]  [<ffffffff813a9b90>] ? xs_watch+0x60/0x60
> [   53.888365]  [<ffffffff810b42e6>] kthread+0xc6/0xd0
> [   53.888371]  [<ffffffff8103a149>] ? xen_end_context_switch+0x19/0x20
> [   53.888378]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.888386]  [<ffffffff8168623c>] ret_from_fork+0x7c/0xb0
> [   53.888392]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.888397] ---[ end trace 918a23c9bada3aed ]---
> [   53.888402] ------------[ cut here ]------------
> [   53.888407] WARNING: at /home/konrad/linux/lib/klist.c:189 klist_release+0x112/0x120()
> [   53.888412] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod libcrc32c crc32c radeon fbcon tileblit font bitblit softcursor ttm drm_kms_helper crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd [last unloaded: e1000e]
> [   53.888478] CPU: 1 PID: 26 Comm: xenwatch Tainted: G        W    3.10.0-rc4upstream-00172-g909fe9e-dirty #2
> [   53.888484]  ffffffff819a3648 ffff88011e3c1b18 ffffffff8167a27d ffff88011e3c1b58
> [   53.888495]  ffffffff8108d1eb 0000000000000010 ffff880109533aa8 ffff880109533a90
> [   53.888506]  ffffffff81421460 0000000000000000 dead000000100100 ffff88011e3c1b68
> [   53.888517] Call Trace:
> [   53.888523]  [<ffffffff8167a27d>] dump_stack+0x19/0x1b
> [   53.888529]  [<ffffffff8108d1eb>] warn_slowpath_common+0x6b/0xa0
> [   53.888536]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.888543]  [<ffffffff8108d235>] warn_slowpath_null+0x15/0x20
> [   53.888549]  [<ffffffff81663c82>] klist_release+0x112/0x120
> [   53.888556]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.888563]  [<ffffffff81663cb8>] klist_dec_and_del+0x28/0x30
> [   53.888601]  [<ffffffff81663eb5>] klist_next+0x45/0x140
> [   53.888608]  [<ffffffff8131c410>] ? pci_match_next_bus+0x10/0x10
> [   53.888615]  [<ffffffff81421108>] class_dev_iter_next+0x18/0x50
> [   53.888621]  [<ffffffff81421358>] class_find_device+0x48/0xb0
> [   53.888628]  [<ffffffff8131c8aa>] pci_get_next_root_bus+0x4a/0x80
> [   53.888634]  [<ffffffff8132f6a5>] pcifront_free_roots+0x25/0x60
> [   53.888640]  [<ffffffff8132f6f1>] free_pdev+0x11/0x80
> [   53.888646]  [<ffffffff8132f77a>] pcifront_xenbus_remove+0x1a/0x20
> [   53.888653]  [<ffffffff813abae8>] xenbus_dev_remove+0x38/0x70
> [   53.888660]  [<ffffffff8141ffc1>] __device_release_driver+0x61/0xd0
> [   53.888667]  [<ffffffff81420148>] device_release_driver+0x28/0x40
> [   53.888673]  [<ffffffff8141f296>] bus_remove_device+0x106/0x140
> [   53.888680]  [<ffffffff8141d120>] device_del+0x110/0x1c0
> [   53.888688]  [<ffffffff8141d1e1>] device_unregister+0x11/0x20
> [   53.888694]  [<ffffffff813ab946>] xenbus_dev_changed+0x96/0x1d0
> [   53.888701]  [<ffffffff81048bd6>] ? xen_spin_lock+0xa6/0x110
> [   53.888708]  [<ffffffff813ad2f6>] frontend_changed+0x16/0x20
> [   53.888714]  [<ffffffff813a9c5b>] xenwatch_thread+0xcb/0x190
> [   53.888721]  [<ffffffff810b49d0>] ? wake_up_bit+0x40/0x40
> [   53.888727]  [<ffffffff813a9b90>] ? xs_watch+0x60/0x60
> [   53.888733]  [<ffffffff810b42e6>] kthread+0xc6/0xd0
> [   53.888739]  [<ffffffff8103a149>] ? xen_end_context_switch+0x19/0x20
> [   53.888746]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.888755]  [<ffffffff8168623c>] ret_from_fork+0x7c/0xb0
> [   53.888761]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.888766] ---[ end trace 918a23c9bada3aee ]---
> [   53.888776] general protection fault: 0000 [#1] SMP 
> [   53.888783] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod libcrc32c crc32c radeon fbcon tileblit font bitblit softcursor ttm drm_kms_helper crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd [last unloaded: e1000e]
> [   53.888847] CPU: 1 PID: 26 Comm: xenwatch Tainted: G        W    3.10.0-rc4upstream-00172-g909fe9e-dirty #2
> [   53.888853] task: ffff88011e2eb800 ti: ffff88011e3c0000 task.ti: ffff88011e3c0000
> [   53.888859] RIP: e030:[<ffffffff81663baa>]  [<ffffffff81663baa>] klist_release+0x3a/0x120
> [   53.888867] RSP: e02b:ffff88011e3c1b78  EFLAGS: 00010292
> [   53.888872] RAX: dead000000200200 RBX: ffff880109533aa8 RCX: 0000006c3739ee67
> [   53.888877] RDX: dead000000100100 RSI: dead000000200200 RDI: dead000000100100
> [   53.888882] RBP: ffff88011e3c1b98 R08: 00000000a589f9bc R09: 0720072007200720
> [   53.888887] R10: 0720072007200720 R11: 0720072007200720 R12: ffff880109533a90
> [   53.888892] R13: ffffffff81421460 R14: 0000000000000000 R15: dead000000100100
> [   53.888900] FS:  00007fe6ef1d97a0(0000) GS:ffff88011f900000(0000) knlGS:0000000000000000
> [   53.888907] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   53.888912] CR2: 00007f1c4090ddd0 CR3: 000000010f0cd000 CR4: 0000000000042660
> [   53.888917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   53.888923] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   53.888928] Stack:
> [   53.888932]  ffff880109533a90 ffff88011e3c1c18 ffff880109533a90 ffffffff81421460
> [   53.888943]  ffff88011e3c1ba8 ffffffff81663cb8 ffff88011e3c1be8 ffffffff81663eb5
> [   53.888954]  0000000000000000 ffff88011e3c1c18 0000000000000000 ffffffff8131c410
> [   53.888965] Call Trace:
> [   53.888971]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.888978]  [<ffffffff81663cb8>] klist_dec_and_del+0x28/0x30
> [   53.888985]  [<ffffffff81663eb5>] klist_next+0x45/0x140
> [   53.888992]  [<ffffffff8131c410>] ? pci_match_next_bus+0x10/0x10
> [   53.888999]  [<ffffffff81421108>] class_dev_iter_next+0x18/0x50
> [   53.889006]  [<ffffffff81421358>] class_find_device+0x48/0xb0
> [   53.889012]  [<ffffffff8131c8aa>] pci_get_next_root_bus+0x4a/0x80
> [   53.889020]  [<ffffffff8132f6a5>] pcifront_free_roots+0x25/0x60
> [   53.889026]  [<ffffffff8132f6f1>] free_pdev+0x11/0x80
> [   53.889032]  [<ffffffff8132f77a>] pcifront_xenbus_remove+0x1a/0x20
> [   53.889039]  [<ffffffff813abae8>] xenbus_dev_remove+0x38/0x70
> [   53.889046]  [<ffffffff8141ffc1>] __device_release_driver+0x61/0xd0
> [   53.889054]  [<ffffffff81420148>] device_release_driver+0x28/0x40
> [   53.889062]  [<ffffffff8141f296>] bus_remove_device+0x106/0x140
> [   53.889064]  [<ffffffff8141d120>] device_del+0x110/0x1c0
> [   53.889064]  [<ffffffff8141d1e1>] device_unregister+0x11/0x20
> [   53.889064]  [<ffffffff813ab946>] xenbus_dev_changed+0x96/0x1d0
> [   53.889064]  [<ffffffff81048bd6>] ? xen_spin_lock+0xa6/0x110
> [   53.889064]  [<ffffffff813ad2f6>] frontend_changed+0x16/0x20
> [   53.889064]  [<ffffffff813a9c5b>] xenwatch_thread+0xcb/0x190
> [   53.889064]  [<ffffffff810b49d0>] ? wake_up_bit+0x40/0x40
> [   53.889064]  [<ffffffff813a9b90>] ? xs_watch+0x60/0x60
> [   53.889064]  [<ffffffff810b42e6>] kthread+0xc6/0xd0
> [   53.889064]  [<ffffffff8103a149>] ? xen_end_context_switch+0x19/0x20
> [   53.889064]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.889064]  [<ffffffff8168623c>] ret_from_fork+0x7c/0xb0
> [   53.889064]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   53.889064] Code: fb 48 83 ec 08 f6 47 e8 01 0f 84 e3 00 00 00 48 8b 43 f8 48 8b 53 f0 48 bf 00 01 10 00 00 00 ad de 48 be 00 02 20 00 00 00 ad de <48> 89 42 08 48 89 10 48 89 7b f0 48 89 73 f8 48 c7 c7 54 44 d7 
> [   53.889064] RIP  [<ffffffff81663baa>] klist_release+0x3a/0x120
> [   53.889064]  RSP <ffff88011e3c1b78>
> [   53.889285] ---[ end trace 918a23c9bada3aef ]---
> [   53.889290] BUG: sleeping function called from invalid context at /home/konrad/linux/kernel/rwsem.c:20
> [   53.889296] in_atomic(): 1, irqs_disabled(): 0, pid: 26, name: xenwatch
> [   53.889302] CPU: 1 PID: 26 Comm: xenwatch Tainted: G      D W    3.10.0-rc4upstream-00172-g909fe9e-dirty #2
> [   53.889307]  000000000000000b ffff88011e3c1928 ffffffff8167a27d ffff88011e3c1938
> [   53.889319]  ffffffff810bf5a8 ffff88011e3c1958 ffffffff8167b56f 0720072007200720
> [   53.889331]  ffff88011e2eb800 ffff88011e3c1998 ffffffff810a279a 0000000000000000
> [   53.889342] Call Trace:
> [   53.889347]  [<ffffffff8167a27d>] dump_stack+0x19/0x1b
> [   53.889354]  [<ffffffff810bf5a8>] __might_sleep+0xd8/0x100
> [   53.889360]  [<ffffffff8167b56f>] down_read+0x1f/0x40
> [   53.889368]  [<ffffffff810a279a>] exit_signals+0x2a/0x170
> [   53.889374]  [<ffffffff81091ddf>] do_exit+0xaf/0xbe0
> [   53.889380]  [<ffffffff8167a12e>] ? printk+0x48/0x4a
> [   53.889387]  [<ffffffff810423f2>] ? check_events+0x12/0x20
> [   53.889394]  [<ffffffff8167f220>] oops_end+0xb0/0xf0
> [   53.889401]  [<ffffffff8104da06>] die+0x56/0x90
> [   53.889407]  [<ffffffff8167effc>] do_general_protection+0xdc/0x160
> [   53.889414]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.889420]  [<ffffffff8167e668>] general_protection+0x28/0x30
> [   53.889427]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.889434]  [<ffffffff81663baa>] ? klist_release+0x3a/0x120
> [   53.889441]  [<ffffffff81663c82>] ? klist_release+0x112/0x120
> [   53.889447]  [<ffffffff81421460>] ? class_for_each_device+0xa0/0xa0
> [   53.889454]  [<ffffffff81663cb8>] klist_dec_and_del+0x28/0x30
> [   53.889461]  [<ffffffff81663eb5>] klist_next+0x45/0x140
> [   53.889467]  [<ffffffff8131c410>] ? pci_match_next_bus+0x10/0x10
> [   53.889473]  [<ffffffff81421108>] class_dev_iter_next+0x18/0x50
> [   53.889480]  [<ffffffff81421358>] class_find_device+0x48/0xb0
> [   53.889486]  [<ffffffff8131c8aa>] pci_get_next_root_bus+0x4a/0x80
> [   53.889493]  [<ffffffff8132f6a5>] pcifront_free_roots+0x25/0x60
> [   54.002497]  [<ffffffff8132f6f1>] free_pdev+0x11/0x80
> [   54.002505]  [<ffffffff8132f77a>] pcifront_xenbus_remove+0x1a/0x20
> [   54.002516]  [<ffffffff813abae8>] xenbus_dev_remove+0x38/0x70
> [   54.002524]  [<ffffffff8141ffc1>] __device_release_driver+0x61/0xd0
> [   54.002530]  [<ffffffff81420148>] device_release_driver+0x28/0x40
> [   54.002537]  [<ffffffff8141f296>] bus_remove_device+0x106/0x140
> [   54.002544]  [<ffffffff8141d120>] device_del+0x110/0x1c0
> [   54.002551]  [<ffffffff8141d1e1>] device_unregister+0x11/0x20
> [   54.002558]  [<ffffffff813ab946>] xenbus_dev_changed+0x96/0x1d0
> [   54.002567]  [<ffffffff81048bd6>] ? xen_spin_lock+0xa6/0x110
> [   54.002574]  [<ffffffff813ad2f6>] frontend_changed+0x16/0x20
> [   54.002581]  [<ffffffff813a9c5b>] xenwatch_thread+0xcb/0x190
> [   54.002588]  [<ffffffff810b49d0>] ? wake_up_bit+0x40/0x40
> [   54.002595]  [<ffffffff813a9b90>] ? xs_watch+0x60/0x60
> [   54.002601]  [<ffffffff810b42e6>] kthread+0xc6/0xd0
> [   54.002607]  [<ffffffff8103a149>] ? xen_end_context_switch+0x19/0x20
> [   54.002615]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   54.002624]  [<ffffffff8168623c>] ret_from_fork+0x7c/0xb0
> [   54.002630]  [<ffffffff810b4220>] ? kthread_freezable_should_stop+0x80/0x80
> [   54.002637] note: xenwatch[26] exited with preempt_count 1
> 
> # 
> # 
> 

