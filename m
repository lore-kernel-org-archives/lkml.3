Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaLPUED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:04:03 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56369 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaLPUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:03:58 -0500
Date: Tue, 16 Dec 2014 12:03:51 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216200351.GA1126@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
 <20141216140952.GA1224@hudson.localdomain>
 <20141216142542.GC22149@ZenIV.linux.org.uk>
 <20141216144610.GA1219@hudson.localdomain>
 <20141216150518.GD22149@ZenIV.linux.org.uk>
 <20141216152626.GA1228@hudson.localdomain>
 <20141216162716.GE22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20141216162716.GE22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Al Viro,

On Tue, Dec 16, 2014 at 04:27:16PM +0000, Al Viro wrote:
> On Tue, Dec 16, 2014 at 07:26:26AM -0800, Jeremiah Mahler wrote:
> 
> > > No such errors happen on the normal boot, presumably?
> > > 
> > > > [    2.392117] EXT4-fs (sda5): mounting ext2 file system using the ext4 subsystem
> > > > [    2.393920] EXT4-fs (sda5): mounted filesystem without journal. Opts: (null)
> > > 
> > > Wait a minute. So that happens _before_ /dev/sda5 mount?  Could you post dmesg
> > > from the normal boot (e.g. just prior to the buggy commit)?
> > > 
> > > I really don't get it - there's nothing for init_fs.root to point to other
> > > than initramfs by that point, CLONE_FS or no CLONE_FS.  We simply don't
> > > have anything else mounted yet.  Do you get another failing bunch of
> > > request_firmware later?  And what does dmesg look like on the working
> > > kernel - either you have that firmware on initramfs image (in which case
> > > it ought to have been picked by both kernels), or you do not, in which case
> > > neither kernel would've managed to load it until after mounting the real
> > > root...
> > 
> > I compiled this kernel with the commit just before the bug was introduced
> > (93fe74b2e2b5d266d630f0c3f8287efcbe6ecd10).  Wireless comes up without
> > any issue.  Here is the dmesg output.
> 
> OK, so the root is on sda6, it's been mounted before those attempts to
> load firmware and init has been chrooted into it, while init_fs got left
> behind.  And that "chrooted into" has happened without pivot_root(2) (or
> it would've been caught by chroot_fs_refs() in sys_pivot_root()) and
> not from the "no /init on initramfs" codepath (you do have it there).
> 
> OK, it's probably unsalvagable, then.  Pity, since it means that PID 1 and
> kernel threads _must_ share ->fs, for the sake of usable ->fs->root, which
> is asking for trouble.  And it means that we still need a sane solution for
> nfsd folks...
> 
> Anyway, dropped that stuff from for-next (and for-linus, obviously), with
> apologies all around.

On a totally different machine, an Acer C720, the sound quit working.
I bisected that one and it pointed to this same commit.  However this
one doesn't involve loading firmware or any of that stuff.  Attached
are the good/bad dmesg logs.

-- 
- Jeremiah Mahler

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc6+ (jeri@newt) (gcc version 4.9.2 (Debian 4.9.2-7) ) #152 SMP Tue Dec 16 11:51:07 PST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc6+ root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000002ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000030000-0x000000000003ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000040000-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000000efffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000f00000-0x0000000000ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000001000000-0x000000007bf79fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007bf7a000-0x000000007e9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001005fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Acer Peppy, BIOS          04/30/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x100600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7F80000000 write-back
[    0.000000]   1 base 007C800000 mask 7FFF800000 uncachable
[    0.000000]   2 base 007D000000 mask 7FFF000000 uncachable
[    0.000000]   3 base 007E000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 write-combining
[    0.000000]   5 base 00FF800000 mask 7FFF800000 uncachable
[    0.000000]   6 base 0100000000 mask 7F00000000 write-back
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7bf7a max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b1a000, 0x01b1afff] PGTABLE
[    0.000000] BRK [0x01b1b000, 0x01b1bfff] PGTABLE
[    0.000000] BRK [0x01b1c000, 0x01b1cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100400000-0x1005fffff]
[    0.000000]  [mem 0x100400000-0x1005fffff] page 2M
[    0.000000] BRK [0x01b1d000, 0x01b1dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1003fffff]
[    0.000000]  [mem 0x100000000-0x1003fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x00efffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x00dfffff] page 2M
[    0.000000]  [mem 0x00e00000-0x00efffff] page 4k
[    0.000000] BRK [0x01b1e000, 0x01b1efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x01000000-0x7bf79fff]
[    0.000000]  [mem 0x01000000-0x7bdfffff] page 2M
[    0.000000]  [mem 0x7be00000-0x7bf79fff] page 4k
[    0.000000] RAMDISK: [mem 0x35364000-0x369a9fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FDBB0 000024 (v02 CORE  )
[    0.000000] ACPI: XSDT 0x000000007BF840E0 000054 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: FACP 0x000000007BF88690 0000F4 (v03 CORE   COREBOOT 00000000 CORE 00000001)
[    0.000000] ACPI: DSDT 0x000000007BF84250 004431 (v02 COREv4 COREBOOT 20110725 INTL 20090123)
[    0.000000] ACPI: FACS 0x000000007BF84210 000040
[    0.000000] ACPI: HPET 0x000000007BF88790 000038 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: APIC 0x000000007BF887D0 00005C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: MCFG 0x000000007BF88830 00003C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: SSDT 0x000000007BF89730 0008A0 (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: SSDT 0x000000007BF89FD0 00005C (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001005fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1005f9000-0x1005fdfff]
[    0.000000]  [ffffea0000000000-ffffea00039fffff] PMD -> [ffff880079800000-ffff88007b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1005fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0002ffff]
[    0.000000]   node   0: [mem 0x00040000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x00efffff]
[    0.000000]   node   0: [mem 0x01000000-0x7bf79fff]
[    0.000000]   node   0: [mem 0x100000000-0x1005fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x1005fffff]
[    0.000000] On node 0 totalpages: 508935
[    0.000000]   DMA zone: 51 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3725 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6887 pages used for memmap
[    0.000000]   DMA32 zone: 503674 pages, LIFO batch:31
[    0.000000]   Normal zone: 21 pages used for memmap
[    0.000000]   Normal zone: 1536 pages, LIFO batch:0
[    0.000000] Reserving Intel graphics stolen memory at 0x7ca00000-0x7e9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00030000-0x0003ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00f00000-0x00ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf7a000-0x7e9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ea00000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xffffffff]
[    0.000000] e820: [mem 0x7ea00000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880100200000 s83648 r8192 d31040 u1048576
[    0.000000] pcpu-alloc: s83648 r8192 d31040 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 501955
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc6+ root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1903968K/2035740K available (5343K kernel code, 1049K rwdata, 1824K rodata, 1212K init, 880K bss, 131772K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:33024 nr_irqs:512 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1396.803 MHz processor
[    0.000047] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.60 BogoMIPS (lpj=5587212)
[    0.000051] pid_max: default: 32768 minimum: 301
[    0.000063] ACPI: Core revision 20140926
[    0.004418] ACPI: All ACPI Tables successfully acquired
[    0.007962] Security Framework initialized
[    0.007973] AppArmor: AppArmor disabled by boot time parameter
[    0.007975] Yama: becoming mindful.
[    0.008228] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008867] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.009148] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.009155] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.009465] Initializing cgroup subsys devices
[    0.009470] Initializing cgroup subsys freezer
[    0.009474] Initializing cgroup subsys net_cls
[    0.009478] Initializing cgroup subsys blkio
[    0.009480] Initializing cgroup subsys perf_event
[    0.009485] Initializing cgroup subsys net_prio
[    0.009523] CPU: Physical Processor ID: 0
[    0.009525] CPU: Processor Core ID: 0
[    0.010880] mce: CPU supports 7 MCE banks
[    0.010899] CPU0: Thermal monitoring enabled (TM1)
[    0.010914] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.011059] Freeing SMP alternatives memory: 20K (ffffffff81a37000 - ffffffff81a3c000)
[    0.012138] ftrace: allocating 21601 entries in 85 pages
[    0.025620] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065307] smpboot: CPU0: Intel(R) Celeron(R) 2955U @ 1.40GHz (fam: 06, model: 45, stepping: 01)
[    0.065316] TSC deadline timer enabled
[    0.065345] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.065376] ... version:                3
[    0.065377] ... bit width:              48
[    0.065378] ... generic registers:      8
[    0.065380] ... value mask:             0000ffffffffffff
[    0.065381] ... max period:             0000ffffffffffff
[    0.065383] ... fixed-purpose events:   3
[    0.065384] ... event mask:             00000007000000ff
[    0.067565] x86: Booting SMP configuration:
[    0.067568] .... node  #0, CPUs:      #1
[    0.082124] x86: Booted up 1 node, 2 CPUs
[    0.082127] smpboot: Total of 2 processors activated (5587.21 BogoMIPS)
[    0.082167] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.084192] devtmpfs: initialized
[    0.088359] pinctrl core: initialized pinctrl subsystem
[    0.088525] NET: Registered protocol family 16
[    0.106136] cpuidle: using governor ladder
[    0.122142] cpuidle: using governor menu
[    0.122210] ACPI: bus type PCI registered
[    0.122213] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.122293] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.122296] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.122418] PCI: Using configuration type 1 for base access
[    0.134673] ACPI: Added _OSI(Module Device)
[    0.134677] ACPI: Added _OSI(Processor Device)
[    0.134678] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.134680] ACPI: Added _OSI(Processor Aggregator Device)
[    0.148366] ACPI: Interpreter enabled
[    0.148374] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.148380] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.148397] ACPI: (supports S0 S3 S4 S5)
[    0.148399] ACPI: Using IOAPIC for interrupt routing
[    0.148428] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.164002] ACPI: Power Resource [TNP0] (off)
[    0.164051] ACPI: Power Resource [TNP1] (on)
[    0.164741] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.164749] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.164804] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.164932] acpi PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cebff])
[    0.164939] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.165180] PCI host bridge to bus 0000:00
[    0.165183] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.165186] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.165188] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.165190] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.165193] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.165195] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.165197] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.165199] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.165201] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.165203] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.165205] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.165207] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.165209] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.165212] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.165214] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.165216] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.165218] pci_bus 0000:00: root bus resource [mem 0x7ea00001-0xfebfffff]
[    0.165220] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.165231] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    0.165379] pci 0000:00:02.0: [8086:0a06] type 00 class 0x030000
[    0.165397] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe03fffff 64bit]
[    0.165407] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.165414] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x183f]
[    0.165551] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    0.165564] pci 0000:00:03.0: reg 0x10: [mem 0xe0510000-0xe0513fff 64bit]
[    0.165725] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    0.165747] pci 0000:00:14.0: reg 0x10: [mem 0xe0500000-0xe050ffff 64bit]
[    0.165819] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.165879] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.165943] pci 0000:00:15.0: [8086:9c60] type 00 class 0x080102
[    0.165964] pci 0000:00:15.0: reg 0x10: [mem 0xe0518000-0xe0518fff]
[    0.165976] pci 0000:00:15.0: reg 0x14: [mem 0xe0519000-0xe0519fff]
[    0.166156] pci 0000:00:15.1: [8086:9c61] type 00 class 0x0c8000
[    0.166182] pci 0000:00:15.1: reg 0x10: [mem 0xe051a000-0xe051afff]
[    0.166194] pci 0000:00:15.1: reg 0x14: [mem 0xe051b000-0xe051bfff]
[    0.166373] pci 0000:00:15.2: [8086:9c62] type 00 class 0x0c8000
[    0.166393] pci 0000:00:15.2: reg 0x10: [mem 0xe051c000-0xe051cfff]
[    0.166405] pci 0000:00:15.2: reg 0x14: [mem 0xe051d000-0xe051dfff]
[    0.166596] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    0.166614] pci 0000:00:1b.0: reg 0x10: [mem 0xe0514000-0xe0517fff 64bit]
[    0.166697] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.166757] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.166817] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    0.166898] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.167029] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    0.167053] pci 0000:00:1d.0: reg 0x10: [mem 0xe051f800-0xe051fbff]
[    0.167159] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.167221] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.167285] pci 0000:00:1f.0: [8086:9c45] type 00 class 0x060100
[    0.167514] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
[    0.167532] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.167542] pci 0000:00:1f.2: reg 0x14: [io  0x1870-0x1873]
[    0.167551] pci 0000:00:1f.2: reg 0x18: [io  0x1868-0x186f]
[    0.167559] pci 0000:00:1f.2: reg 0x1c: [io  0x1874-0x1877]
[    0.167568] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.167577] pci 0000:00:1f.2: reg 0x24: [mem 0xe051f000-0xe051f7ff]
[    0.167623] pci 0000:00:1f.2: PME# supported from D3hot
[    0.167732] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    0.167749] pci 0000:00:1f.3: reg 0x10: [mem 0xe051fc00-0xe051fcff 64bit]
[    0.167773] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.167904] pci 0000:00:1f.6: [8086:9c24] type 00 class 0x118000
[    0.167938] pci 0000:00:1f.6: reg 0x10: [mem 0xe051e000-0xe051efff 64bit]
[    0.168228] pci 0000:01:00.0: [168c:0034] type 00 class 0x028000
[    0.168256] pci 0000:01:00.0: reg 0x10: [mem 0xe0400000-0xe047ffff 64bit]
[    0.168316] pci 0000:01:00.0: reg 0x30: [mem 0xe0480000-0xe048ffff pref]
[    0.168394] pci 0000:01:00.0: supports D1 D2
[    0.168397] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.174200] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.174206] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.174352] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.174417] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10, disabled.
[    0.174478] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.174537] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.174595] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.174654] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.174712] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.174769] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.175540] ACPI : EC: GPE = 0x24, I/O: command/status = 0x66, data = 0x62
[    0.175685] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.175688] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.175692] vgaarb: loaded
[    0.175694] vgaarb: bridge control possible 0000:00:02.0
[    0.175799] PCI: Using ACPI for IRQ routing
[    0.177453] PCI: pci_cache_line_size set to 64 bytes
[    0.177507] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.177509] e820: reserve RAM buffer [mem 0x7bf7a000-0x7bffffff]
[    0.177511] e820: reserve RAM buffer [mem 0x100600000-0x103ffffff]
[    0.177711] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.177719] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.179752] Switched to clocksource hpet
[    0.189200] pnp: PnP ACPI init
[    0.189325] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.189329] system 00:00: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.189332] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.189334] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.189337] system 00:00: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.189340] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.189343] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.189346] system 00:00: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    0.189348] system 00:00: [mem 0x00f00000-0x00ffffff] has been reserved
[    0.189353] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.189668] system 00:01: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.189672] system 00:01: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.189759] system 00:02: [io  0x1000-0x10fe] could not be reserved
[    0.189763] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.189797] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.189853] system 00:04: [io  0x0900-0x09fe] has been reserved
[    0.189856] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.189909] system 00:05: [io  0x0200] has been reserved
[    0.189912] system 00:05: [io  0x0204] has been reserved
[    0.189914] system 00:05: [io  0x0800-0x087f] has been reserved
[    0.189917] system 00:05: [io  0x0880-0x08ff] has been reserved
[    0.189920] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.189967] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.190012] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.190063] pnp 00:08: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.190182] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.190326] pnp: PnP ACPI: found 10 devices
[    0.197432] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.197439] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.197449] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.197452] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.197454] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.197456] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.197458] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.197460] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.197463] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.197465] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.197467] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.197469] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.197471] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.197473] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.197475] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.197477] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.197479] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff]
[    0.197481] pci_bus 0000:00: resource 19 [mem 0x7ea00001-0xfebfffff]
[    0.197484] pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed44fff]
[    0.197486] pci_bus 0000:01: resource 1 [mem 0xe0400000-0xe04fffff]
[    0.197543] NET: Registered protocol family 2
[    0.197783] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.197864] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    0.198053] TCP: Hash tables configured (established 16384 bind 16384)
[    0.198080] TCP: reno registered
[    0.198093] UDP hash table entries: 1024 (order: 4, 98304 bytes)
[    0.198140] UDP-Lite hash table entries: 1024 (order: 4, 98304 bytes)
[    0.198259] NET: Registered protocol family 1
[    0.198283] pci 0000:00:02.0: Video device with shadowed ROM
[    0.198848] PCI: CLS 64 bytes, default 64
[    0.198914] Unpacking initramfs...
[    0.813574] Freeing initrd memory: 22808K (ffff880035364000 - ffff8800369aa000)
[    0.813600] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.813604] software IO TLB [mem 0x75800000-0x79800000] (64MB) mapped at [ffff880075800000-ffff8800797fffff]
[    0.813807] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.813885] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x15
[    0.813894] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x15
[    0.813974] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.814379] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.814430] audit: initializing netlink subsys (disabled)
[    0.814454] audit: type=2000 audit(1418759606.812:1): initialized
[    0.814933] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.814969] zpool: loaded
[    0.814973] zbud: loaded
[    0.815207] VFS: Disk quotas dquot_6.5.2
[    0.815230] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.815297] msgmni has been set to 3763
[    0.815781] alg: No test for stdrng (krng)
[    0.815815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.815855] io scheduler noop registered
[    0.815859] io scheduler deadline registered
[    0.815873] io scheduler cfq registered (default)
[    0.816142] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.816285] aer 0000:00:1c.0:pcie02: service driver aer loaded
[    0.816311] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.816314] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.816318] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.816330] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.816357] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.816436] intel_idle: MWAIT substates: 0x11142120
[    0.816437] intel_idle: v0.4 model 0x45
[    0.816439] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.816695] GHES: HEST is not enabled!
[    0.816789] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.817454] Linux agpgart interface v0.103
[    0.817612] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.817614] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.818151] i8042: Warning: Keylock active
[    0.818340] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.818535] mousedev: PS/2 mouse device common for all mice
[    0.818597] rtc_cmos 00:03: RTC can wake from S4
[    0.818773] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.818803] rtc_cmos 00:03: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.818821] Intel P-state driver initializing.
[    0.818969] ledtrig-cpu: registered to indicate activity on CPUs
[    0.819232] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.819235] AMD IOMMUv2 functionality not available on this system
[    0.819452] TCP: cubic registered
[    0.819547] NET: Registered protocol family 10
[    0.820023] mip6: Mobile IPv6
[    0.820048] NET: Registered protocol family 17
[    0.820069] mpls_gso: MPLS GSO support
[    0.821014] registered taskstats version 1
[    0.821735] rtc_cmos 00:03: setting system clock to 2014-12-16 19:53:27 UTC (1418759607)
[    0.823888] Freeing unused kernel memory: 1212K (ffffffff81908000 - ffffffff81a37000)
[    0.823891] Write protecting the kernel read-only data: 8192k
[    0.828035] Freeing unused kernel memory: 788K (ffff88000153b000 - ffff880001600000)
[    0.829175] Freeing unused kernel memory: 224K (ffff8800017c8000 - ffff880001800000)
[    0.829306] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.847257] systemd-udevd[62]: starting version 215
[    0.847733] random: systemd-udevd urandom read with 2 bits of entropy available
[    0.864116] SCSI subsystem initialized
[    0.867936] libata version 3.00 loaded.
[    0.869381] ahci 0000:00:1f.2: version 3.0
[    0.869571] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.869591] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.869608] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x1 impl SATA mode
[    0.869612] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo only pio slum part deso sadm sds apst 
[    0.872169] scsi host0: ahci
[    0.873076] scsi host1: ahci
[    0.873164] ata1: SATA max UDMA/133 abar m2048@0xe051f000 port 0xe051f100 irq 41
[    0.873167] ata2: DUMMY
[    0.873540] thermal LNXTHERM:00: registered as thermal_zone0
[    0.873544] ACPI: Thermal Zone [THRM] (46 C)
[    0.876360] sdhci: Secure Digital Host Controller Interface driver
[    0.876364] sdhci: Copyright(c) Pierre Ossman
[    1.191664] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.191923] ata1.00: ATA-10: SC2 M2 SSD, S9FM01.7, max UDMA/100
[    1.191928] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.192198] ata1.00: configured for UDMA/100
[    1.192384] scsi 0:0:0:0: Direct-Access     ATA      SC2 M2 SSD       01.7 PQ: 0 ANSI: 5
[    1.194720] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    1.194778] sd 0:0:0:0: [sda] Write Protect is off
[    1.194782] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.194799] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.195387]  sda: sda1 sda2 < sda5 >
[    1.196247] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.197053] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.352763] PM: Starting manual resume from disk
[    1.407162] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.705439] fuse init (API version 7.23)
[    1.755855] systemd-udevd[163]: starting version 215
[    1.811508] tsc: Refined TSC clocksource calibration: 1396.766 MHz
[    1.878941] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    1.895289] systemd-journald[144]: Received request to flush runtime journal from PID 1
[    1.934532] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.934617] ACPI: Lid Switch [LID0]
[    1.937908] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    1.937917] ACPI: Power Button [PWRB]
[    1.938002] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    1.938006] ACPI: Sleep Button [TPAD]
[    1.938076] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:01/input/input4
[    1.938080] ACPI: Sleep Button [TSCR]
[    1.938169] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    1.938173] ACPI: Power Button [PWRF]
[    1.944438] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.944655] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    1.967363] ACPI: Battery Slot [BAT0] (battery present)
[    1.969255] ACPI: AC Adapter [AC] (on-line)
[    1.972621] tpm_tis tpm_tis: 1.2 TPM (device-id 0xB, rev-id 16)
[    2.023898] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.032367] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    2.034674] ACPI: bus type USB registered
[    2.034718] usbcore: registered new interface driver usbfs
[    2.034736] usbcore: registered new interface driver hub
[    2.036956] usbcore: registered new device driver usb
[    2.040377] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    2.066278] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    2.095526] [drm] Initialized drm 1.1.0 20060810
[    2.096996] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.097008] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.097109] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.097132] xhci_hcd 0000:00:14.0: irq 43 for MSI/MSI-X
[    2.097493] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.097496] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.097498] usb usb1: Product: xHCI Host Controller
[    2.097501] usb usb1: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.097503] usb usb1: SerialNumber: 0000:00:14.0
[    2.097792] hub 1-0:1.0: USB hub found
[    2.097808] hub 1-0:1.0: 8 ports detected
[    2.098211] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.098217] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.098260] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.098263] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.098265] usb usb2: Product: xHCI Host Controller
[    2.098267] usb usb2: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.098269] usb usb2: SerialNumber: 0000:00:14.0
[    2.098427] hub 2-0:1.0: USB hub found
[    2.098437] hub 2-0:1.0: 4 ports detected
[    2.100748] sound hdaudioC1D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    2.100753] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.100756] sound hdaudioC1D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    2.100758] sound hdaudioC1D0:    mono: mono_out=0x0
[    2.100760] sound hdaudioC1D0:    inputs:
[    2.100763] sound hdaudioC1D0:      Internal Mic=0x1a
[    2.100766] sound hdaudioC1D0:      Mic=0x19
[    2.118151] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input8
[    2.118385] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[    2.118467] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[    2.141706] __add_probed_i2c_device failed to register device 1-4a
[    2.160140] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.184445] cfg80211: Calling CRDA to update world regulatory domain
[    2.193384] alg: No test for crc32 (crc32-pclmul)
[    2.220459] iTCO_vendor_support: vendor-support=0
[    2.223193] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.223241] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1060)
[    2.223776] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.224531] __add_probed_i2c_device failed to register device 1-4a
[    2.224547] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.251264] input: Cypress APA Trackpad (cyapa) as /devices/pci0000:00/0000:00:15.1/i2c-0/0-0067/input/input11
[    2.255229] __add_probed_i2c_device failed to register device 1-4a
[    2.255241] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.257607] RPC: Registered named UNIX socket transport module.
[    2.257611] RPC: Registered udp transport module.
[    2.257613] RPC: Registered tcp transport module.
[    2.257614] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.264947] [drm] Memory usable by graphics device = 2048M
[    2.264954] [drm] Replacing VGA console driver
[    2.265119] tpm_inf_pnp 00:08: Found TPM with ID IFX0102
[    2.266402] Console: switching to colour dummy device 80x25
[    2.268048] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    2.268063] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.268065] [drm] Driver supports precise vblank timestamp query.
[    2.268108] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.268165] [drm] applying backlight present quirk
[    2.277627] FS-Cache: Loaded
[    2.316428] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    2.317916] __add_probed_i2c_device failed to register device 1-4a
[    2.317929] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.318811] fbcon: inteldrmfb (fb0) is primary device
[    2.349401] FS-Cache: Netfs 'nfs' registered for caching
[    2.403691] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.410475] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.411628] ath: phy0: ASPM enabled: 0x43
[    2.411630] ath: EEPROM regdomain: 0x6c
[    2.411631] ath: EEPROM indicates we should expect a direct regpair map
[    2.411633] ath: Country alpha2 being used: 00
[    2.411633] ath: Regpair used: 0x6c
[    2.427302] cfg80211: World regulatory domain updated:
[    2.427304] cfg80211:  DFS Master region: unset
[    2.427305] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.427307] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.427309] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.427310] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.427311] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    2.427313] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.427314] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.427315] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.427316] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.428215] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    2.428535] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xffffc90004580000, irq=16
[    2.429411] __add_probed_i2c_device failed to register device 1-4a
[    2.429412] chromeos_laptop_probe: Ran out of tries for device.
[    2.435191] intel_rapl: Found RAPL domain package
[    2.435194] intel_rapl: Found RAPL domain core
[    2.435196] intel_rapl: Found RAPL domain uncore
[    2.435199] intel_rapl: Found RAPL domain dram
[    2.664449] usb 1-3: New USB device found, idVendor=1bcf, idProduct=2c67
[    2.664453] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.664455] usb 1-3: Product: HD WebCam
[    2.664457] usb 1-3: Manufacturer: NC.21411.024409008DCLM0001
[    2.748233] media: Linux media interface: v0.10
[    2.761067] Linux video capture interface: v2.00
[    2.779665] uvcvideo: Found UVC 1.00 device HD WebCam (1bcf:2c67)
[    2.788668] input: HD WebCam as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/input/input12
[    2.788776] usbcore: registered new interface driver uvcvideo
[    2.788777] USB Video Class driver (1.1.1)
[    2.811617] Switched to clocksource tsc
[    2.899409] usb 1-4: new full-speed USB device number 3 using xhci_hcd
[    3.029104] usb 1-4: language id specifier not provided by device, defaulting to English
[    3.030976] usb 1-4: New USB device found, idVendor=0489, idProduct=e056
[    3.030978] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.071870] Bluetooth: Core ver 2.19
[    3.071901] NET: Registered protocol family 31
[    3.071902] Bluetooth: HCI device and connection manager initialized
[    3.071912] Bluetooth: HCI socket layer initialized
[    3.071915] Bluetooth: L2CAP socket layer initialized
[    3.071925] Bluetooth: SCO socket layer initialized
[    3.075804] usbcore: registered new interface driver btusb
[    3.078086] usbcore: registered new interface driver ath3k
[    3.199364] usb 1-5: new low-speed USB device number 4 using xhci_hcd
[    3.379415] Console: switching to colour frame buffer device 170x48
[    3.383083] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.383084] i915 0000:00:02.0: registered panic notifier
[    3.389614] usb 1-5: New USB device found, idVendor=046d, idProduct=c062
[    3.389620] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.389623] usb 1-5: Product: USB Laser Mouse
[    3.389625] usb 1-5: Manufacturer: Logitech
[    3.389757] usb 1-5: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    3.399277] snd_hda_intel 0000:00:03.0: irq 45 for MSI/MSI-X
[    3.402767] hidraw: raw HID events driver (C) Jiri Kosina
[    3.415487] usbcore: registered new interface driver usbhid
[    3.415491] usbhid: USB HID core driver
[    3.416466] Adding 4069372k swap on /dev/sda5.  Priority:-1 extents:1 across:4069372k SSFS
[    3.418208] input: Logitech USB Laser Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/0003:046D:C062.0001/input/input13
[    3.419398] hid-generic 0003:046D:C062.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Laser Mouse] on usb-0000:00:14.0-5/input0
[    3.424128] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input14
[    3.424440] systemd-journald[144]: Received request to flush runtime journal from PID 1
[    3.427295] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input15
[    3.427559] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input16
[    3.588066] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.588071] Bluetooth: BNEP filters: protocol multicast
[    3.588081] Bluetooth: BNEP socket layer initialized
[    4.454337] random: nonblocking pool is initialized
[    7.409423] wlan0: authenticate with 00:1a:70:5a:6e:0b
[    7.419278] wlan0: send auth to 00:1a:70:5a:6e:0b (try 1/3)
[    7.421357] wlan0: authenticated
[    7.421643] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[    7.421651] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[    7.422714] wlan0: associate with 00:1a:70:5a:6e:0b (try 1/3)
[    7.428617] wlan0: RX AssocResp from 00:1a:70:5a:6e:0b (capab=0x401 status=0 aid=3)
[    7.428722] wlan0: associated

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc6+ (jeri@newt) (gcc version 4.9.2 (Debian 4.9.2-7) ) #151 SMP Tue Dec 16 11:48:55 PST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc6+ root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000002ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000030000-0x000000000003ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000040000-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000000efffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000f00000-0x0000000000ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000001000000-0x000000007bf79fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007bf7a000-0x000000007e9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001005fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Acer Peppy, BIOS          04/30/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x100600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7F80000000 write-back
[    0.000000]   1 base 007C800000 mask 7FFF800000 uncachable
[    0.000000]   2 base 007D000000 mask 7FFF000000 uncachable
[    0.000000]   3 base 007E000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 write-combining
[    0.000000]   5 base 00FF800000 mask 7FFF800000 uncachable
[    0.000000]   6 base 0100000000 mask 7F00000000 write-back
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7bf7a max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b1a000, 0x01b1afff] PGTABLE
[    0.000000] BRK [0x01b1b000, 0x01b1bfff] PGTABLE
[    0.000000] BRK [0x01b1c000, 0x01b1cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100400000-0x1005fffff]
[    0.000000]  [mem 0x100400000-0x1005fffff] page 2M
[    0.000000] BRK [0x01b1d000, 0x01b1dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1003fffff]
[    0.000000]  [mem 0x100000000-0x1003fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x00efffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x00dfffff] page 2M
[    0.000000]  [mem 0x00e00000-0x00efffff] page 4k
[    0.000000] BRK [0x01b1e000, 0x01b1efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x01000000-0x7bf79fff]
[    0.000000]  [mem 0x01000000-0x7bdfffff] page 2M
[    0.000000]  [mem 0x7be00000-0x7bf79fff] page 4k
[    0.000000] RAMDISK: [mem 0x35364000-0x369a9fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FDBB0 000024 (v02 CORE  )
[    0.000000] ACPI: XSDT 0x000000007BF840E0 000054 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: FACP 0x000000007BF88690 0000F4 (v03 CORE   COREBOOT 00000000 CORE 00000001)
[    0.000000] ACPI: DSDT 0x000000007BF84250 004431 (v02 COREv4 COREBOOT 20110725 INTL 20090123)
[    0.000000] ACPI: FACS 0x000000007BF84210 000040
[    0.000000] ACPI: HPET 0x000000007BF88790 000038 (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: APIC 0x000000007BF887D0 00005C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: MCFG 0x000000007BF88830 00003C (v01 CORE   COREBOOT 00000000 CORE 00000000)
[    0.000000] ACPI: SSDT 0x000000007BF89730 0008A0 (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: SSDT 0x000000007BF89FD0 00005C (v02 CORE   COREBOOT 0000002A CORE 0000002A)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001005fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1005f9000-0x1005fdfff]
[    0.000000]  [ffffea0000000000-ffffea00039fffff] PMD -> [ffff880079800000-ffff88007b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1005fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0002ffff]
[    0.000000]   node   0: [mem 0x00040000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x00efffff]
[    0.000000]   node   0: [mem 0x01000000-0x7bf79fff]
[    0.000000]   node   0: [mem 0x100000000-0x1005fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x1005fffff]
[    0.000000] On node 0 totalpages: 508935
[    0.000000]   DMA zone: 51 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3725 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6887 pages used for memmap
[    0.000000]   DMA32 zone: 503674 pages, LIFO batch:31
[    0.000000]   Normal zone: 21 pages used for memmap
[    0.000000]   Normal zone: 1536 pages, LIFO batch:0
[    0.000000] Reserving Intel graphics stolen memory at 0x7ca00000-0x7e9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00030000-0x0003ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00f00000-0x00ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf7a000-0x7e9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ea00000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xffffffff]
[    0.000000] e820: [mem 0x7ea00000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880100200000 s83648 r8192 d31040 u1048576
[    0.000000] pcpu-alloc: s83648 r8192 d31040 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 501955
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc6+ root=UUID=e5fd0a8b-e57d-428c-831e-3aff30526800 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1903968K/2035740K available (5343K kernel code, 1049K rwdata, 1824K rodata, 1212K init, 880K bss, 131772K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:33024 nr_irqs:512 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1396.801 MHz processor
[    0.000048] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.60 BogoMIPS (lpj=5587204)
[    0.000052] pid_max: default: 32768 minimum: 301
[    0.000063] ACPI: Core revision 20140926
[    0.004434] ACPI: All ACPI Tables successfully acquired
[    0.007681] Security Framework initialized
[    0.007692] AppArmor: AppArmor disabled by boot time parameter
[    0.007693] Yama: becoming mindful.
[    0.007953] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008593] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.008873] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.008880] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.009191] Initializing cgroup subsys devices
[    0.009196] Initializing cgroup subsys freezer
[    0.009201] Initializing cgroup subsys net_cls
[    0.009204] Initializing cgroup subsys blkio
[    0.009207] Initializing cgroup subsys perf_event
[    0.009211] Initializing cgroup subsys net_prio
[    0.009250] CPU: Physical Processor ID: 0
[    0.009251] CPU: Processor Core ID: 0
[    0.010607] mce: CPU supports 7 MCE banks
[    0.010625] CPU0: Thermal monitoring enabled (TM1)
[    0.010641] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.010785] Freeing SMP alternatives memory: 20K (ffffffff81a37000 - ffffffff81a3c000)
[    0.011870] ftrace: allocating 21601 entries in 85 pages
[    0.025147] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064828] smpboot: CPU0: Intel(R) Celeron(R) 2955U @ 1.40GHz (fam: 06, model: 45, stepping: 01)
[    0.064837] TSC deadline timer enabled
[    0.064866] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.064898] ... version:                3
[    0.064899] ... bit width:              48
[    0.064900] ... generic registers:      8
[    0.064902] ... value mask:             0000ffffffffffff
[    0.064903] ... max period:             0000ffffffffffff
[    0.064904] ... fixed-purpose events:   3
[    0.064906] ... event mask:             00000007000000ff
[    0.066898] x86: Booting SMP configuration:
[    0.066901] .... node  #0, CPUs:      #1
[    0.081454] x86: Booted up 1 node, 2 CPUs
[    0.081459] smpboot: Total of 2 processors activated (5587.20 BogoMIPS)
[    0.081498] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.083521] devtmpfs: initialized
[    0.087711] pinctrl core: initialized pinctrl subsystem
[    0.087879] NET: Registered protocol family 16
[    0.105468] cpuidle: using governor ladder
[    0.121475] cpuidle: using governor menu
[    0.121544] ACPI: bus type PCI registered
[    0.121547] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.121628] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.121631] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.121748] PCI: Using configuration type 1 for base access
[    0.138007] ACPI: Added _OSI(Module Device)
[    0.138010] ACPI: Added _OSI(Processor Device)
[    0.138012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.138014] ACPI: Added _OSI(Processor Aggregator Device)
[    0.151697] ACPI: Interpreter enabled
[    0.151706] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.151712] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.151730] ACPI: (supports S0 S3 S4 S5)
[    0.151732] ACPI: Using IOAPIC for interrupt routing
[    0.151762] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.171342] ACPI: Power Resource [TNP0] (off)
[    0.171391] ACPI: Power Resource [TNP1] (on)
[    0.172082] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.172090] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.172144] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.172274] acpi PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cebff])
[    0.172281] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.172520] PCI host bridge to bus 0000:00
[    0.172524] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.172527] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.172529] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.172531] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.172534] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.172536] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.172538] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.172540] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.172542] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.172544] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.172547] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.172549] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.172551] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.172553] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.172555] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.172557] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.172560] pci_bus 0000:00: root bus resource [mem 0x7ea00001-0xfebfffff]
[    0.172562] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.172573] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    0.172720] pci 0000:00:02.0: [8086:0a06] type 00 class 0x030000
[    0.172738] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe03fffff 64bit]
[    0.172748] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.172755] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x183f]
[    0.172892] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    0.172905] pci 0000:00:03.0: reg 0x10: [mem 0xe0510000-0xe0513fff 64bit]
[    0.173066] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    0.173088] pci 0000:00:14.0: reg 0x10: [mem 0xe0500000-0xe050ffff 64bit]
[    0.173161] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.173220] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.173285] pci 0000:00:15.0: [8086:9c60] type 00 class 0x080102
[    0.173305] pci 0000:00:15.0: reg 0x10: [mem 0xe0518000-0xe0518fff]
[    0.173318] pci 0000:00:15.0: reg 0x14: [mem 0xe0519000-0xe0519fff]
[    0.173497] pci 0000:00:15.1: [8086:9c61] type 00 class 0x0c8000
[    0.173523] pci 0000:00:15.1: reg 0x10: [mem 0xe051a000-0xe051afff]
[    0.173535] pci 0000:00:15.1: reg 0x14: [mem 0xe051b000-0xe051bfff]
[    0.173714] pci 0000:00:15.2: [8086:9c62] type 00 class 0x0c8000
[    0.173735] pci 0000:00:15.2: reg 0x10: [mem 0xe051c000-0xe051cfff]
[    0.173747] pci 0000:00:15.2: reg 0x14: [mem 0xe051d000-0xe051dfff]
[    0.173937] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    0.173956] pci 0000:00:1b.0: reg 0x10: [mem 0xe0514000-0xe0517fff 64bit]
[    0.174037] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.174097] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.174157] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    0.174237] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.174367] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    0.174391] pci 0000:00:1d.0: reg 0x10: [mem 0xe051f800-0xe051fbff]
[    0.174497] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.174558] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.174622] pci 0000:00:1f.0: [8086:9c45] type 00 class 0x060100
[    0.174850] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
[    0.174868] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.174877] pci 0000:00:1f.2: reg 0x14: [io  0x1870-0x1873]
[    0.174886] pci 0000:00:1f.2: reg 0x18: [io  0x1868-0x186f]
[    0.174895] pci 0000:00:1f.2: reg 0x1c: [io  0x1874-0x1877]
[    0.174904] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.174913] pci 0000:00:1f.2: reg 0x24: [mem 0xe051f000-0xe051f7ff]
[    0.174958] pci 0000:00:1f.2: PME# supported from D3hot
[    0.175067] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    0.175084] pci 0000:00:1f.3: reg 0x10: [mem 0xe051fc00-0xe051fcff 64bit]
[    0.175108] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.175239] pci 0000:00:1f.6: [8086:9c24] type 00 class 0x118000
[    0.175274] pci 0000:00:1f.6: reg 0x10: [mem 0xe051e000-0xe051efff 64bit]
[    0.175563] pci 0000:01:00.0: [168c:0034] type 00 class 0x028000
[    0.175591] pci 0000:01:00.0: reg 0x10: [mem 0xe0400000-0xe047ffff 64bit]
[    0.175651] pci 0000:01:00.0: reg 0x30: [mem 0xe0480000-0xe048ffff pref]
[    0.175729] pci 0000:01:00.0: supports D1 D2
[    0.175731] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.181536] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.181543] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.181688] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.181754] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10, disabled.
[    0.181815] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.181874] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.181934] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.181992] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.182051] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.182109] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.182885] ACPI : EC: GPE = 0x24, I/O: command/status = 0x66, data = 0x62
[    0.183031] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.183034] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.183038] vgaarb: loaded
[    0.183040] vgaarb: bridge control possible 0000:00:02.0
[    0.183145] PCI: Using ACPI for IRQ routing
[    0.184800] PCI: pci_cache_line_size set to 64 bytes
[    0.184852] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.184855] e820: reserve RAM buffer [mem 0x7bf7a000-0x7bffffff]
[    0.184857] e820: reserve RAM buffer [mem 0x100600000-0x103ffffff]
[    0.185057] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.185065] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.187099] Switched to clocksource hpet
[    0.196568] pnp: PnP ACPI init
[    0.196693] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.196696] system 00:00: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.196699] system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.196702] system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.196705] system 00:00: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.196708] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.196710] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.196713] system 00:00: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    0.196716] system 00:00: [mem 0x00f00000-0x00ffffff] has been reserved
[    0.196721] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197038] system 00:01: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.197042] system 00:01: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.197130] system 00:02: [io  0x1000-0x10fe] could not be reserved
[    0.197133] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197167] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.197223] system 00:04: [io  0x0900-0x09fe] has been reserved
[    0.197226] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197279] system 00:05: [io  0x0200] has been reserved
[    0.197281] system 00:05: [io  0x0204] has been reserved
[    0.197284] system 00:05: [io  0x0800-0x087f] has been reserved
[    0.197286] system 00:05: [io  0x0880-0x08ff] has been reserved
[    0.197289] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197336] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.197380] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.197433] pnp 00:08: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.197551] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197696] pnp: PnP ACPI: found 10 devices
[    0.204792] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.204800] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe04fffff]
[    0.204810] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.204813] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.204815] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.204817] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.204819] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.204821] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.204824] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.204826] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.204828] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.204830] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.204832] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.204834] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.204836] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.204838] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.204841] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff]
[    0.204843] pci_bus 0000:00: resource 19 [mem 0x7ea00001-0xfebfffff]
[    0.204845] pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed44fff]
[    0.204848] pci_bus 0000:01: resource 1 [mem 0xe0400000-0xe04fffff]
[    0.204906] NET: Registered protocol family 2
[    0.205150] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.205231] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    0.205419] TCP: Hash tables configured (established 16384 bind 16384)
[    0.205446] TCP: reno registered
[    0.205459] UDP hash table entries: 1024 (order: 4, 98304 bytes)
[    0.205505] UDP-Lite hash table entries: 1024 (order: 4, 98304 bytes)
[    0.205624] NET: Registered protocol family 1
[    0.205647] pci 0000:00:02.0: Video device with shadowed ROM
[    0.206200] PCI: CLS 64 bytes, default 64
[    0.206267] Unpacking initramfs...
[    0.813162] Freeing initrd memory: 22808K (ffff880035364000 - ffff8800369aa000)
[    0.813189] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.813193] software IO TLB [mem 0x75800000-0x79800000] (64MB) mapped at [ffff880075800000-ffff8800797fffff]
[    0.813393] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.813470] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x15
[    0.813481] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x15
[    0.813554] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.813925] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.813975] audit: initializing netlink subsys (disabled)
[    0.814002] audit: type=2000 audit(1418759441.812:1): initialized
[    0.814481] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.814519] zpool: loaded
[    0.814524] zbud: loaded
[    0.814759] VFS: Disk quotas dquot_6.5.2
[    0.814783] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.814855] msgmni has been set to 3763
[    0.815330] alg: No test for stdrng (krng)
[    0.815369] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.815410] io scheduler noop registered
[    0.815415] io scheduler deadline registered
[    0.815430] io scheduler cfq registered (default)
[    0.815696] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.815838] aer 0000:00:1c.0:pcie02: service driver aer loaded
[    0.815864] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.815866] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.815871] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.815882] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.815912] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.815992] intel_idle: MWAIT substates: 0x11142120
[    0.815994] intel_idle: v0.4 model 0x45
[    0.815996] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.816257] GHES: HEST is not enabled!
[    0.816359] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.817028] Linux agpgart interface v0.103
[    0.817188] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.817190] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.817730] i8042: Warning: Keylock active
[    0.817864] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.818025] mousedev: PS/2 mouse device common for all mice
[    0.818088] rtc_cmos 00:03: RTC can wake from S4
[    0.818271] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.818301] rtc_cmos 00:03: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.818319] Intel P-state driver initializing.
[    0.818466] ledtrig-cpu: registered to indicate activity on CPUs
[    0.818729] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.818732] AMD IOMMUv2 functionality not available on this system
[    0.818949] TCP: cubic registered
[    0.819070] NET: Registered protocol family 10
[    0.819528] mip6: Mobile IPv6
[    0.819540] NET: Registered protocol family 17
[    0.819560] mpls_gso: MPLS GSO support
[    0.820472] registered taskstats version 1
[    0.821189] rtc_cmos 00:03: setting system clock to 2014-12-16 19:50:42 UTC (1418759442)
[    0.823239] Freeing unused kernel memory: 1212K (ffffffff81908000 - ffffffff81a37000)
[    0.823241] Write protecting the kernel read-only data: 8192k
[    0.825921] Freeing unused kernel memory: 788K (ffff88000153b000 - ffff880001600000)
[    0.826648] Freeing unused kernel memory: 224K (ffff8800017c8000 - ffff880001800000)
[    0.826734] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.840410] systemd-udevd[62]: starting version 215
[    0.840790] random: systemd-udevd urandom read with 2 bits of entropy available
[    0.858223] SCSI subsystem initialized
[    0.862893] libata version 3.00 loaded.
[    0.866817] ahci 0000:00:1f.2: version 3.0
[    0.867540] sdhci: Secure Digital Host Controller Interface driver
[    0.867543] sdhci: Copyright(c) Pierre Ossman
[    0.868859] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.868881] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.868899] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x1 impl SATA mode
[    0.868903] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo only pio slum part deso sadm sds apst 
[    0.869284] thermal LNXTHERM:00: registered as thermal_zone0
[    0.869288] ACPI: Thermal Zone [THRM] (47 C)
[    0.870361] scsi host0: ahci
[    0.871139] scsi host1: ahci
[    0.871426] ata1: SATA max UDMA/133 abar m2048@0xe051f000 port 0xe051f100 irq 41
[    0.871430] ata2: DUMMY
[    1.191012] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.191255] ata1.00: ATA-10: SC2 M2 SSD, S9FM01.7, max UDMA/100
[    1.191260] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.191495] ata1.00: configured for UDMA/100
[    1.191683] scsi 0:0:0:0: Direct-Access     ATA      SC2 M2 SSD       01.7 PQ: 0 ANSI: 5
[    1.194034] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    1.194106] sd 0:0:0:0: [sda] Write Protect is off
[    1.194110] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.194126] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.194632]  sda: sda1 sda2 < sda5 >
[    1.195181] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.195966] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.390307] PM: Starting manual resume from disk
[    1.443340] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.738711] fuse init (API version 7.23)
[    1.767220] systemd-udevd[161]: starting version 215
[    1.810865] tsc: Refined TSC clocksource calibration: 1396.766 MHz
[    1.895743] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    1.906859] systemd-journald[143]: Received request to flush runtime journal from PID 1
[    1.942596] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.942650] ACPI: Lid Switch [LID0]
[    1.942721] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    1.942726] ACPI: Power Button [PWRB]
[    1.942786] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    1.942789] ACPI: Sleep Button [TPAD]
[    1.943374] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:01/input/input4
[    1.943380] ACPI: Sleep Button [TSCR]
[    1.943470] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    1.943474] ACPI: Power Button [PWRF]
[    1.953650] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.953850] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    1.970488] tpm_tis tpm_tis: 1.2 TPM (device-id 0xB, rev-id 16)
[    1.977159] ACPI: AC Adapter [AC] (on-line)
[    1.978892] ACPI: Battery Slot [BAT0] (battery present)
[    2.027883] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.028319] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    2.052233] ACPI: bus type USB registered
[    2.055603] usbcore: registered new interface driver usbfs
[    2.055623] usbcore: registered new interface driver hub
[    2.055652] usbcore: registered new device driver usb
[    2.062020] [drm] Initialized drm 1.1.0 20060810
[    2.070560] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    2.097681] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.097695] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.097792] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.097816] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    2.102014] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.102020] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.102023] usb usb1: Product: xHCI Host Controller
[    2.102025] usb usb1: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.102027] usb usb1: SerialNumber: 0000:00:14.0
[    2.102322] hub 1-0:1.0: USB hub found
[    2.102337] hub 1-0:1.0: 8 ports detected
[    2.102696] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.102702] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.104015] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.104019] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.104021] usb usb2: Product: xHCI Host Controller
[    2.104023] usb usb2: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.104025] usb usb2: SerialNumber: 0000:00:14.0
[    2.104222] hub 2-0:1.0: USB hub found
[    2.104232] hub 2-0:1.0: 4 ports detected
[    2.114638] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    2.122849] hda-i915: get_power symbol get fail
[    2.122856] snd_hda_intel 0000:00:03.0: Error request power-well from i915
[    2.136091] __add_probed_i2c_device failed to register device 1-4a
[    2.136420] cfg80211: Calling CRDA to update world regulatory domain
[    2.151282] sound hdaudioC1D0: No codec parser is available
[    2.152647] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.167921] alg: No test for crc32 (crc32-pclmul)
[    2.236543] tpm_inf_pnp 00:08: Found TPM with ID IFX0102
[    2.238749] input: Cypress APA Trackpad (cyapa) as /devices/pci0000:00/0000:00:15.1/i2c-0/0-0067/input/input8
[    2.243087] RPC: Registered named UNIX socket transport module.
[    2.243091] RPC: Registered udp transport module.
[    2.243093] RPC: Registered tcp transport module.
[    2.243095] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.245577] iTCO_vendor_support: vendor-support=0
[    2.248181] __add_probed_i2c_device failed to register device 1-4a
[    2.248194] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.263888] FS-Cache: Loaded
[    2.271609] Adding 4069372k swap on /dev/sda5.  Priority:-1 extents:1 across:4069372k SSFS
[    2.296567] [drm] Memory usable by graphics device = 2048M
[    2.296573] [drm] Replacing VGA console driver
[    2.297442] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.297487] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1060)
[    2.297702] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.298268] Console: switching to colour dummy device 80x25
[    2.298380] __add_probed_i2c_device failed to register device 1-4a
[    2.298391] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.300718] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    2.300731] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.300733] [drm] Driver supports precise vblank timestamp query.
[    2.300779] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.300835] [drm] applying backlight present quirk
[    2.349111] FS-Cache: Netfs 'nfs' registered for caching
[    2.360332] cfg80211: World regulatory domain updated:
[    2.360338] cfg80211:  DFS Master region: unset
[    2.360339] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.360343] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.360345] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.360347] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.360349] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    2.360352] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.360354] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.360356] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.360358] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.363273] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    2.364442] __add_probed_i2c_device failed to register device 1-4a
[    2.364457] platform chromeos_laptop: Driver chromeos_laptop requests probe deferral
[    2.364778] fbcon: inteldrmfb (fb0) is primary device
[    2.376786] __add_probed_i2c_device failed to register device 1-4a
[    2.376788] chromeos_laptop_probe: Ran out of tries for device.
[    2.398574] ath: phy0: ASPM enabled: 0x43
[    2.398576] ath: EEPROM regdomain: 0x6c
[    2.398577] ath: EEPROM indicates we should expect a direct regpair map
[    2.398579] ath: Country alpha2 being used: 00
[    2.398579] ath: Regpair used: 0x6c
[    2.399654] ieee80211 phy0: Failed to initialize wep: -2
[    2.399662] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    2.399975] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xffffc90004c00000, irq=16
[    2.401746] intel_rapl: Found RAPL domain package
[    2.401747] intel_rapl: Found RAPL domain core
[    2.401748] intel_rapl: Found RAPL domain uncore
[    2.401749] intel_rapl: Found RAPL domain dram
[    2.402451] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.410806] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.663948] usb 1-3: New USB device found, idVendor=1bcf, idProduct=2c67
[    2.663950] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.663951] usb 1-3: Product: HD WebCam
[    2.663953] usb 1-3: Manufacturer: NC.21411.024409008DCLM0001
[    2.747080] media: Linux media interface: v0.10
[    2.760705] Linux video capture interface: v2.00
[    2.778940] uvcvideo: Found UVC 1.00 device HD WebCam (1bcf:2c67)
[    2.787711] input: HD WebCam as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/input/input9
[    2.787831] usbcore: registered new interface driver uvcvideo
[    2.787832] USB Video Class driver (1.1.1)
[    2.810926] Switched to clocksource tsc
[    2.898772] usb 1-4: new full-speed USB device number 3 using xhci_hcd
[    3.028431] usb 1-4: language id specifier not provided by device, defaulting to English
[    3.030299] usb 1-4: New USB device found, idVendor=0489, idProduct=e056
[    3.030302] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.069888] Bluetooth: Core ver 2.19
[    3.069913] NET: Registered protocol family 31
[    3.069914] Bluetooth: HCI device and connection manager initialized
[    3.069923] Bluetooth: HCI socket layer initialized
[    3.069926] Bluetooth: L2CAP socket layer initialized
[    3.069941] Bluetooth: SCO socket layer initialized
[    3.073978] usbcore: registered new interface driver btusb
[    3.076150] usbcore: registered new interface driver ath3k
[    3.155225] Bluetooth: Unable to create crypto context
[    3.198708] usb 1-5: new low-speed USB device number 4 using xhci_hcd
[    3.388581] usb 1-5: New USB device found, idVendor=046d, idProduct=c062
[    3.388583] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.388585] usb 1-5: Product: USB Laser Mouse
[    3.388586] usb 1-5: Manufacturer: Logitech
[    3.388844] usb 1-5: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    3.399997] hidraw: raw HID events driver (C) Jiri Kosina
[    3.408880] usbcore: registered new interface driver usbhid
[    3.408881] usbhid: USB HID core driver
[    3.411080] input: Logitech USB Laser Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/0003:046D:C062.0001/input/input10
[    3.411203] hid-generic 0003:046D:C062.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Laser Mouse] on usb-0000:00:14.0-5/input0
[    3.434750] Console: switching to colour frame buffer device 170x48
[    3.438486] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.438488] i915 0000:00:02.0: registered panic notifier
[    3.622675] systemd-journald[143]: Received request to flush runtime journal from PID 1
[    4.685623] random: nonblocking pool is initialized
[    7.432426] wlan0: authenticate with 00:1a:70:5a:6e:0b
[    7.442193] wlan0: send auth to 00:1a:70:5a:6e:0b (try 1/3)
[    7.444230] wlan0: authenticated
[    7.444536] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[    7.444543] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[    7.445950] wlan0: associate with 00:1a:70:5a:6e:0b (try 1/3)
[    7.452935] wlan0: RX AssocResp from 00:1a:70:5a:6e:0b (capab=0x401 status=0 aid=3)
[    7.453041] wlan0: associated

--2oS5YaxWCcQjTEyO--
