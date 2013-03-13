Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3CMHqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:46:37 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:46524 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3CMHqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:46:35 -0400
Message-ID: <51402ED5.6000902@openvz.org>
Date: Wed, 13 Mar 2013 11:46:29 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3.9.0-rc1: kexec not working: root disk does not show up
References: <20130308171704.GE8219@redhat.com> <20130312192922.GA2268@redhat.com>
In-Reply-To: <20130312192922.GA2268@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Mar 08, 2013 at 12:17:04PM -0500, Vivek Goyal wrote:
>> Hi,
>>
>> With 3.9.0-rc1, kexec seems to have stopped working on my system. 3.8.0
>> works just fine.
>>
>> In second kernel root disk does not show up. Dracut waits for quite some
>> time and then gives up.
>>
>> My root is on SATA disk. None of the SATA disks are up. Not sure but
>> looking at the logs, I am wondering if it is SATA driver related issue.
>>
>> [   17.564011] ata4.00: qc timeout (cmd 0xec)
>> [   17.568179] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.574339] ata4: limiting SATA link speed to 1.5 Gbps
>> [   17.579549] ata1.00: qc timeout (cmd 0xec)
>> [   17.583716] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.589864] ata1: limiting SATA link speed to 1.5 Gbps
>> [   17.595070] ata2.00: qc timeout (cmd 0xa1)
>> [   17.599231] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.605379] ata2: limiting SATA link speed to 1.5 Gbps
>> [   17.610593] ata6.00: qc timeout (cmd 0xec)
>> [   17.614760] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.620908] ata6: limiting SATA link speed to 1.5 Gbps
>> [   17.626120] ata3.00: qc timeout (cmd 0xec)
>> [   17.630280] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.636427] ata3: limiting SATA link speed to 1.5 Gbps
>> [   17.913016] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.919279] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.931019] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.943016] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.949275] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>>
>> Following are the console logs of second kernel boot through kexec. And
>> after that also attaching console logs for regular first kernel boot.
>
> Ok, some more observation.
>
> - Problem seems to be in during shutdown path. Because older kernel 3.8
>    can kexec into newer kernel 3.9.rc1 but not vice-a-versa.
>
> I did git bisecting and following commit seems to be problem.
>
> commit 7897e6022761ace7377f0f784fca059da55f5d71
> Author: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Date:   Mon Feb 4 15:55:58 2013 +0400
>
>      PCI: Disable Bus Master unconditionally in pci_device_shutdown()
>
>      Commit b566a22c23 ("PCI: disable Bus Master on PCI device shutdown")
>      used pci_disable_device(), but that doesn't disable Bus Mastering
>      unconditionally; we allow nested enable/disable calls, and only the
>      last disable call actually does anything.
>
>      This uses pci_clear_master() to unconditionally clear the Bus Master
>      bit.
>
>      Matthew Garrett and Alan Cox said (see LKML link below) that clearing
> Bus
>      Master for all PCI devices may lead to unpredictable consequences:
> some
>      devices ignores this bit and continue DMA, some of them hang after
> that or
>      crash the whole system.  But we're already trying to clear Bus Master
> in
>      general because of b566a22c23; this merely deals with the cases where
>      drivers haven't shut down the device correctly.
>
>      [bhelgaas: changelog]
>      Link: https://lkml.org/lkml/2012/6/6/278
>      Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>      Signed-off-by: Bjorn Helgaas<bhelgaas@google.com>
>      Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
>
> I reverted above commit and things work again. Just that I get following
> warning during shutdown.
>
> [   54.252516] ------------[ cut here ]------------
> [   54.257199] WARNING: at drivers/pci/pci.c:1397
> pci_disable_device+0x90/0xa0()
> [   54.264387] Hardware name: HP xw6600 Workstation
> [   54.269061] Device pci
> disabling already-disabled device
> [   54.274341] Modules linked in: floppy
> [   54.278403] Pid: 5272, comm: kexec Not tainted 3.9.0-rc2+ #207
> [   54.284289] Call Trace:
> [   54.286801]  [<ffffffff8133c600>] ? pci_disable_device+0x60/0xa0
> [   54.292864]  [<ffffffff8103e49f>] warn_slowpath_common+0x7f/0xc0
> [   54.298926]  [<ffffffff8103e596>] warn_slowpath_fmt+0x46/0x50
> [   54.304727]  [<ffffffff8133c592>] ? do_pci_disable_device+0x52/0x60
> [   54.311050]  [<ffffffff8133c630>] pci_disable_device+0x90/0xa0
> [   54.316938]  [<ffffffff8133e1a4>] pci_device_shutdown+0x44/0x50
> [   54.322915]  [<ffffffff81462b2d>] device_shutdown+0x1d/0x180
> [   54.328631]  [<ffffffff81056ba6>] kernel_restart_prepare+0x36/0x50
> [   54.334866]  [<ffffffff810a16c0>] kernel_kexec+0x50/0x80
> [   54.340235]  [<ffffffff81056e35>] sys_reboot+0x1f5/0x260
> [   54.345604]  [<ffffffff811621b9>] ? mntput_no_expire+0x49/0x160
> [   54.351578]  [<ffffffff811622f6>] ? mntput+0x26/0x40
> [   54.356601]  [<ffffffff81144539>] ? __fput+0x1a9/0x280
> [   54.361798]  [<ffffffff8105fae4>] ? task_work_run+0xc4/0xe0
> [   54.367428]  [<ffffffff810029a5>] ? do_notify_resume+0x75/0x80
> [   54.373319]  [<ffffffff81882742>] system_call_fastpath+0x16/0x1b
> [   54.379382] ---[ end trace ea6ecbf97debf2e2 ]---
> [   54.385157] Starting new kernel
>
>
> I am leaving the logs from previous mail intact so that newly CCed
> people can have a look at it and don't go hunting for old mail in
> lkml archives.
>
> Thanks
> Vivek
>

Look like I fixed one bug and added another.
After ->shutdown() device can be in D3-cold state and config space is unreachable.

try this patch

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -385,6 +385,12 @@ static void pci_device_shutdown(struct device *dev)

         if (drv && drv->shutdown)
                 drv->shutdown(pci_dev);
+
+       if (pci_dev->current_state == PCI_D3cold) {
+               WARN_ON(pci_dev->msi_enabled || pci_dev->msix_enabled);
+               return;
+       }
+
         pci_msi_shutdown(pci_dev);
         pci_msix_shutdown(pci_dev);


>>
>> [   78.286132] Starting new kernel
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.9.0-rc1+ (<edited>) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #168 SMP Fri Mar 8 11:26:01 EST 2013
>> [    0.000000] Command line: ro root=UUID=90e92cac-8f9b-464d-9e00-11491cc4bf8e rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=tty0 console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x0000000000096fff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000097000-0x000000000009ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffc283f] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000bffc2840-0x00000000bfffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] SMBIOS 2.5 present.
>> [    0.000000] No AGP bridge found
>> [    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
>> [    0.000000] e820: last_pfn = 0xbffc2 max_arch_pfn = 0x400000000
>> [    0.000000] found SMP MP-table at [mem 0x000fe700-0x000fe70f] mapped at [ffff8800000fe700]
>> [    0.000000] Scanning 1 areas for low memory corruption
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> [    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
>> [    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
>> [    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
>> [    0.000000] init_memory_mapping: [mem 0x00100000-0xbffc1fff]
>> [    0.000000] RAMDISK: [mem 0x7fb80000-0x7fff4fff]
>> [    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System RAM: 4095MB)
>> [    0.000000] ACPI: RSDP 00000000000e9810 00024 (v02 HPQOEM)
>> [    0.000000] ACPI: XSDT 00000000bffc52ec 0006C (v01 HPQOEM SLIC-WKS 20070918      00000000)
>> [    0.000000] ACPI: FACP 00000000bffc5494 000F4 (v03 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI BIOS Bug: Error: 32/64X address mismatch in FADT/Gpe0Block: 0x0000F828/0x000000000001F030, using 32 (20130117/tbfadt-462)
>> [    0.000000] ACPI: DSDT 00000000bffc5a6e 02697 (v01 HPQOEM     DSDT 00000001 MSFT 0100000E)
>> [    0.000000] ACPI: FACS 00000000bffc5200 00040
>> [    0.000000] ACPI: SSDT 00000000bffc8105 06A92 (v01 HPQOEM  PROJECT 00000001 MSFT 0100000E)
>> [    0.000000] ACPI: APIC 00000000bffc5588 000C8 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: ASF! 00000000bffc5650 0006A (v32 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: MCFG 00000000bffc5852 0003C (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: SLIC 00000000bffc588e 00176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
>> [    0.000000] ACPI: HPET 00000000bffc5a04 00038 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: TCPA 00000000bffc5a3c 00032 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: DMAR 00000000bffc56ba 00108 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
>> [    0.000000]   NODE_DATA [mem 0x13fff9000-0x13fffcfff]
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>> [    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x00001000-0x00096fff]
>> [    0.000000]   node   0: [mem 0x00100000-0xbffc1fff]
>> [    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
>> [    0.000000] ACPI: PM-Timer IO Port: 0xf808
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
>> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
>> [    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec89000, GSI 24-47
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
>> [    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
>> [    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
>> [    0.000000] PM: Registered nosave memory: 00000000bffc2000 - 00000000bffc3000
>> [    0.000000] PM: Registered nosave memory: 00000000bffc3000 - 00000000c0000000
>> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
>> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
>> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
>> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
>> [    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
>> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013fc00000 s80000 r8192 d22400 u262144
>> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032002
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: ro root=UUID=90e92cac-8f9b-464d-9e00-11491cc4bf8e rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=tty0 console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] __ex_table already sorted, skipping sort
>> [    0.000000] Checking aperture...
>> [    0.000000] No AGP bridge found
>> [    0.000000] Memory: 3907908k/5242880k available (8771k kernel code, 1049248k absent, 285724k reserved, 6390k data, 1160k init)
>> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
>> [    0.000000] NR_IRQS:4352 nr_irqs:1152 16
>> [    0.000000] Console: colour VGA+ 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] console [ttyS0] enabled
>> [    0.000000] tsc: Fast TSC calibration using PIT
>> [    0.000000] tsc: Detected 2333.212 MHz processor
>> [    0.003004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.42 BogoMIPS (lpj=2333212)
>> [    0.005003] pid_max: default: 32768 minimum: 301
>> [    0.006037] Security Framework initialized
>> [    0.007006] SELinux:  Disabled at boot.
>> [    0.009034] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> [    0.012165] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>> [    0.014109] Mount-cache hash table entries: 256
>> [    0.015275] Initializing cgroup subsys cpuacct
>> [    0.016004] Initializing cgroup subsys freezer
>> [    0.017003] Initializing cgroup subsys blkio
>> [    0.018041] CPU: Physical Processor ID: 0
>> [    0.019003] CPU: Processor Core ID: 0
>> [    0.020003] mce: CPU supports 6 MCE banks
>> [    0.021015] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
>> [    0.021015] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
>> [    0.021015] tlb_flushall_shift: -1
>> [    0.022108] Freeing SMP alternatives: 28k freed
>> [    0.023017] ACPI: Core revision 20130117
>> [    0.026741] ACPI: All ACPI Tables successfully acquired
>> [    0.029012] ftrace: allocating 30474 entries in 120 pages
>> [    0.038566] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.039000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>> [    0.039000] ...trying to set up timer (IRQ0) through the 8259A ...
>> [    0.039000] ..... (found apic 0 pin 2) ...
>> [    0.039000] ....... failed.
>> [    0.039000] ...trying to set up timer as Virtual Wire IRQ...
>> [    0.049837] ..... works.
>> [    0.050001] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.33GHz (fam: 06, model: 17, stepping: 04)
>> [    0.055000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
>> [    0.059002] ... version:                2
>> [    0.060001] ... bit width:              40
>> [    0.061001] ... generic registers:      2
>> [    0.062001] ... value mask:             000000ffffffffff
>> [    0.063001] ... max period:             000000007fffffff
>> [    0.064001] ... fixed-purpose events:   3
>> [    0.065001] ... event mask:             0000000700000003
>> [    0.067132] smpboot: Booting Node   0, Processors  #1 #2 #3
>> [    0.106013] Brought up 4 CPUs
>> [    0.107003] smpboot: Total of 4 processors activated (18665.69 BogoMIPS)
>> [    0.110027] EVM: security.selinux
>> [    0.111002] EVM: security.ima
>> [    0.112001] EVM: security.capability
>> [    0.113311] xor: measuring software checksum speed
>> [    0.124002]    prefetch64-sse: 10032.000 MB/sec
>> [    0.135002]    generic_sse:  8868.000 MB/sec
>> [    0.136001] xor: using function: prefetch64-sse (10032.000 MB/sec)
>> [    0.137021] RTC time: 11:34:18, date: 03/08/13
>> [    0.138061] NET: Registered protocol family 16
>> [    0.140097] ACPI: bus type PCI registered
>> [    0.141030] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.142007] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
>> [    0.158208] PCI: Using configuration type 1 for base access
>> [    0.180046] bio: create slab<bio-0>  at 0
>> [    0.200279] raid6: sse2x1    3210 MB/s
>> [    0.220281] raid6: sse2x2    5792 MB/s
>> [    0.240279] raid6: sse2x4    6367 MB/s
>> [    0.244002] raid6: using algorithm sse2x4 (6367 MB/s)
>> [    0.249002] raid6: using ssse3x2 recovery algorithm
>> [    0.254021] ACPI: Added _OSI(Module Device)
>> [    0.259004] ACPI: Added _OSI(Processor Device)
>> [    0.264002] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.269002] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.287016] ACPI: SSDT 00000000bffd07c1 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
>> [    0.295577] ACPI: Dynamic OEM Table Load:
>> [    0.300255] ACPI: SSDT           (null) 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
>> [    0.314303] ACPI: Interpreter enabled
>> [    0.318007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
>> [    0.328002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
>> [    0.337010] ACPI: (supports S0 S3 S4 S5)
>> [    0.341002] ACPI: Using IOAPIC for interrupt routing
>> [    0.346024] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
>> [    0.371038] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.377054] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20130117/dsfield-211)
>> [    0.387002] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88013aa61c30), AE_ALREADY_EXISTS (20130117/psparse-537)
>> [    0.399002] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
>> [    0.407045] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20130117/dsfield-211)
>> [    0.416002] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88013aa61c30), AE_ALREADY_EXISTS (20130117/psparse-537)
>> [    0.429006] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [    0.437002] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
>> [    0.445055] PCI host bridge to bus 0000:00
>> [    0.449005] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.455003] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
>> [    0.461002] pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffffff]
>> [    0.469088] pci 0000:00:01.0: System wakeup disabled by ACPI
>> [    0.474092] pci 0000:00:05.0: System wakeup disabled by ACPI
>> [    0.480093] pci 0000:00:09.0: System wakeup disabled by ACPI
>> [    0.488198] pci 0000:00:1c.0: System wakeup disabled by ACPI
>> [    0.494124] pci 0000:00:1d.0: System wakeup disabled by ACPI
>> [    0.500108] pci 0000:00:1d.1: System wakeup disabled by ACPI
>> [    0.506105] pci 0000:00:1d.2: System wakeup disabled by ACPI
>> [    0.512107] pci 0000:00:1d.3: System wakeup disabled by ACPI
>> [    0.517165] pci 0000:00:1d.7: System wakeup disabled by ACPI
>> [    0.523090] pci 0000:00:1e.0: System wakeup disabled by ACPI
>> [    0.530184] pci 0000:00:01.0: PCI bridge to [bus 80]
>> [    0.535072] pci 0000:60:00.0: System wakeup disabled by ACPI
>> [    0.543013] pci 0000:00:05.0: PCI bridge to [bus 60]
>> [    0.559008] pci 0000:00:09.0: PCI bridge to [bus 10-40]
>> [    0.569972] pci 0000:1e:00.0: System wakeup disabled by ACPI
>> [    0.580060] pci 0000:1e:01.0: System wakeup disabled by ACPI
>> [    0.587184] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
>> [    0.595031] pci 0000:1e:00.0: PCI bridge to [bus 20]
>> [    0.606331] pci 0000:40:00.0: System wakeup disabled by ACPI
>> [    0.612281] pci 0000:1e:01.0: PCI bridge to [bus 40]
>> [    0.621230] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
>> [    0.628272] pci 0000:0e:00.0: System wakeup disabled by ACPI
>> [    0.636052] pci 0000:00:1c.0: PCI bridge to [bus 0e]
>> [    0.641052] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
>> [    0.648032] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [    0.655324] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15), disabled.
>> [    0.663054] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
>> [    0.671307] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15), disabled.
>> [    0.680314] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
>> [    0.688307] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
>> [    0.697314] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15), disabled.
>> [    0.705306] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
>> [    0.714311] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
>> [    0.723080] ACPI: No dock devices found.
>> [    0.727034] vgaarb: device added: PCI:0000:60:00.0,decodes=io+mem,owns=io+mem,locks=none
>> [    0.735004] vgaarb: loaded
>> [    0.738001] vgaarb: bridge control possible 0000:60:00.0
>> [    0.744075] SCSI subsystem initialized
>> [    0.748004] ACPI: bus type ATA registered
>> [    0.752034] ACPI: bus type USB registered
>> [    0.756034] usbcore: registered new interface driver usbfs
>> [    0.762020] usbcore: registered new interface driver hub
>> [    0.767035] usbcore: registered new device driver usb
>> [    0.773034] pps_core: LinuxPPS API ver. 1 registered
>> [    0.778009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti<giometti@linux.it>
>> [    0.787019] PTP clock support registered
>> [    0.791043] Advanced Linux Sound Architecture Driver Initialized.
>> [    0.798003] PCI: Using ACPI for IRQ routing
>> [    0.850063] cfg80211: Calling CRDA to update world regulatory domain
>> [    0.852127] NetLabel: Initializing
>> [    0.852128] NetLabel:  domain hash size = 128
>> [    0.852129] NetLabel:  protocols = UNLABELED CIPSOv4
>> [    0.852177] NetLabel:  unlabeled traffic allowed by default
>> [    0.852208] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
>> [    0.852208] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> [    0.852208] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> [    0.893076] Switching to clocksource hpet
>> [    0.903801] pnp: PnP ACPI init
>> [    0.906931] ACPI: bus type PNP registered
>> [    0.912914] system 00:0b: [io  0x04d0-0x04d1] has been reserved
>> [    0.919062] system 00:0c: [io  0x0400-0x041f] has been reserved
>> [    0.925046] system 00:0c: [io  0x0420-0x043f] has been reserved
>> [    0.931032] system 00:0c: [io  0x0440-0x045f] has been reserved
>> [    0.937019] system 00:0c: [io  0x0460-0x047f] has been reserved
>> [    0.943005] system 00:0c: [io  0x0480-0x048f] has been reserved
>> [    0.948990] system 00:0c: [io  0x0490-0x049f] has been reserved
>> [    0.954977] system 00:0c: [io  0xf800-0xf81f] has been reserved
>> [    0.960964] system 00:0c: [io  0xf820-0xf83f] has been reserved
>> [    0.966951] system 00:0c: [io  0xf840-0xf85f] has been reserved
>> [    0.972938] system 00:0c: [io  0xf860-0xf87f] has been reserved
>> [    0.978925] system 00:0c: [io  0xfa00-0xfa3f] has been reserved
>> [    0.984911] system 00:0c: [io  0xfc00-0xfc7f] has been reserved
>> [    0.990898] system 00:0c: [io  0xfc80-0xfcff] has been reserved
>> [    0.996885] system 00:0c: [io  0xfe00-0xfe7f] has been reserved
>> [    1.002872] system 00:0c: [io  0xfe80-0xfeff] has been reserved
>> [    1.008991] system 00:0d: [mem 0xfed1c000-0xfed1ffff] has been reserved
>> [    1.015668] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
>> [    1.022350] system 00:0d: [mem 0xfee00000-0xfeefffff] has been reserved
>> [    1.029031] system 00:0d: [mem 0xfe700000-0xfe7003ff] has been reserved
>> [    1.035712] system 00:0d: [mem 0xfe600000-0xfe6fffff] has been reserved
>> [    1.042393] system 00:0d: [mem 0xfe000000-0xfe01ffff] has been reserved
>> [    1.049354] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
>> [    1.056380] system 00:0e: [mem 0x000c0000-0x000e7fff] could not be reserved
>> [    1.063408] system 00:0e: [mem 0x000e8000-0x000effff] could not be reserved
>> [    1.070436] system 00:0e: [mem 0x000f0000-0x000fffff] could not be reserved
>> [    1.077464] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
>> [    1.084495] system 00:0e: [mem 0xfeda0000-0xfedbffff] has been reserved
>> [    1.091327] system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
>> [    1.098030] pnp: PnP ACPI: found 16 devices
>> [    1.102277] ACPI: bus type PNP unregistered
>> [    1.118954] pci 0000:0e:00.0: no compatible bridge window for [mem 0xde7e0000-0xde7effff pref]
>> [    1.128749] pci 0000:00:01.0: PCI bridge to [bus 80]
>> [    1.133794] pci 0000:60:00.0: BAR 6: can't assign mem pref (size 0x20000)
>> [    1.140642] pci 0000:00:05.0: PCI bridge to [bus 60]
>> [    1.145677] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
>> [    1.151839] pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
>> [    1.158694] pci 0000:00:05.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
>> [    1.166541] pci 0000:1e:00.0: PCI bridge to [bus 20]
>> [    1.171944] pci 0000:40:00.0: BAR 6: assigned [mem 0xf3400000-0xf347ffff pref]
>> [    1.179265] pci 0000:1e:01.0: PCI bridge to [bus 40]
>> [    1.184299] pci 0000:1e:01.0:   bridge window [io  0x2000-0x2fff]
>> [    1.190551] pci 0000:1e:01.0:   bridge window [mem 0xf3100000-0xf31fffff]
>> [    1.197447] pci 0000:1e:01.0:   bridge window [mem 0xf3400000-0xf34fffff 64bit pref]
>> [    1.205424] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
>> [    1.210713] pci 0000:10:00.0:   bridge window [io  0x2000-0x2fff]
>> [    1.216966] pci 0000:10:00.0:   bridge window [mem 0xf3100000-0xf31fffff]
>> [    1.223859] pci 0000:10:00.0:   bridge window [mem 0xf3400000-0xf34fffff 64bit pref]
>> [    1.231835] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
>> [    1.237492] pci 0000:00:09.0: PCI bridge to [bus 10-40]
>> [    1.242781] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
>> [    1.248943] pci 0000:00:09.0:   bridge window [mem 0xf3100000-0xf32fffff]
>> [    1.255798] pci 0000:00:09.0:   bridge window [mem 0xf3400000-0xf34fffff 64bit pref]
>> [    1.263645] pci 0000:0e:00.0: BAR 6: assigned [mem 0xf3500000-0xf350ffff pref]
>> [    1.270969] pci 0000:00:1c.0: PCI bridge to [bus 0e]
>> [    1.276004] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
>> [    1.282162] pci 0000:00:1c.0:   bridge window [mem 0xf3000000-0xf30fffff]
>> [    1.289018] pci 0000:00:1c.0:   bridge window [mem 0xf3500000-0xf36fffff 64bit pref]
>> [    1.296865] pci 0000:00:1e.0: PCI bridge to [bus 01]
>> [    1.303293] NET: Registered protocol family 2
>> [    1.307928] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
>> [    1.315542] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
>> [    1.322741] TCP: Hash tables configured (established 32768 bind 32768)
>> [    1.329384] TCP: reno registered
>> [    1.332694] UDP hash table entries: 2048 (order: 5, 196608 bytes)
>> [    1.338949] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
>> [    1.346469] NET: Registered protocol family 1
>> [    1.351012] RPC: Registered named UNIX socket transport module.
>> [    1.356996] RPC: Registered udp transport module.
>> [    1.361766] RPC: Registered tcp transport module.
>> [    1.366535] RPC: Registered tcp NFSv4.1 backchannel transport module.
>> [    1.374378] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
>> [    1.380936] Trying to unpack rootfs image as initramfs...
>> [    1.470967] Freeing initrd memory: 4564k freed
>> [    1.477127] dmar: Host address width 36
>> [    1.481034] dmar: DRHD base: 0x000000fe710000 flags: 0x0
>> [    1.486434] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.494272] dmar: DRHD base: 0x000000fe714000 flags: 0x0
>> [    1.499653] dmar: IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.507499] dmar: DRHD base: 0x000000fe719000 flags: 0x0
>> [    1.512878] dmar: IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.520720] dmar: DRHD base: 0x000000fe718000 flags: 0x1
>> [    1.526100] dmar: IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.533943] dmar: RMRR base: 0x000000bffd3000 end: 0x000000bffd3fff
>> [    1.540273] dmar: RMRR base: 0x000000bffd4000 end: 0x000000bffd4fff
>> [    1.546602] dmar: RMRR base: 0x000000bffd5000 end: 0x000000bffd5fff
>> [    1.552931] dmar: RMRR base: 0x000000bffd6000 end: 0x000000bffd6fff
>> [    1.559275] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    1.565780] software IO TLB [mem 0xbbfc2000-0xbffc2000] (64MB) mapped at [ffff8800bbfc2000-ffff8800bffc1fff]
>> [    1.577157] microcode: CPU0 sig=0x10674, pf=0x40, revision=0x404
>> [    1.583224] microcode: CPU1 sig=0x10674, pf=0x40, revision=0x404
>> [    1.589304] microcode: CPU2 sig=0x10674, pf=0x40, revision=0x404
>> [    1.595375] microcode: CPU3 sig=0x10674, pf=0x40, revision=0x404
>> [    1.601536] microcode: Microcode Update Driver: v2.00<tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> [    1.610416] Scanning for low memory corruption every 60 seconds
>> [    1.616959] Initialise module verification
>> [    1.621181] audit: initializing netlink socket (disabled)
>> [    1.626667] type=2000 audit(1362742457.625:1): initialized
>> [    1.664001] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>> [    1.677912] VFS: Disk quotas dquot_6.5.2
>> [    1.682043] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    1.690900] NFS: Registering the id_resolver key type
>> [    1.696024] Key type id_resolver registered
>> [    1.700279] Key type id_legacy registered
>> [    1.704466] msgmni has been set to 7641
>> [    1.709276] Key type asymmetric registered
>> [    1.713444] Asymmetric key parser 'x509' registered
>> [    1.718587] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
>> [    1.726134] io scheduler noop registered
>> [    1.730124] io scheduler deadline registered
>> [    1.734579] io scheduler cfq registered (default)
>> [    1.743917] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> [    1.749986] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
>> [    1.758437] ACPI: Power Button [PBTN]
>> [    1.762292] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    1.769785] ACPI: Power Button [PWRF]
>> [    1.773899] ACPI: Requesting acpi_cpufreq
>> [    1.781088] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    1.808005] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    1.814873] Non-volatile memory driver v1.3
>> [    1.819226] Linux agpgart interface v0.103
>> [    1.823870] [drm] Initialized drm 1.1.0 20060810
>> [    1.832523] brd: module loaded
>> [    1.837698] loop: module loaded
>> [    1.841684] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
>> [    1.849958] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
>> [    1.858330] scsi0 : ahci
>> [    1.861210] scsi1 : ahci
>> [    1.864056] scsi2 : ahci
>> [    1.866914] scsi3 : ahci
>> [    1.869769] scsi4 : ahci
>> [    1.872626] scsi5 : ahci
>> [    1.875419] ata1: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304500 irq 19
>> [    1.882915] ata2: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304580 irq 19
>> [    1.890413] ata3: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304600 irq 19
>> [    1.897910] ata4: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304680 irq 19
>> [    1.905407] ata5: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304700 irq 19
>> [    1.912904] ata6: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304780 irq 19
>> [    1.921786] scsi6 : ata_piix
>> [    1.924968] scsi7 : ata_piix
>> [    1.928098] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30c0 irq 14
>> [    1.935120] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30c8 irq 15
>> [    1.942775] tg3.c:v3.130 (February 14, 2013)
>> [    1.972566] tg3 0000:0e:00.0 eth0: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:19:bb:ea:3c:7d
>> [    1.982920] tg3 0000:0e:00.0 eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
>> [    1.992757] tg3 0000:0e:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
>> [    2.000682] tg3 0000:0e:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
>> [    2.007587] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
>> [    2.013742] e100: Copyright(c) 1999-2006 Intel Corporation
>> [    2.019389] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
>> [    2.026500] e1000: Copyright (c) 1999-2006 Intel Corporation.
>> [    2.032406] sky2: driver version 1.30
>> [    2.036725] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    2.043325] ehci-pci: EHCI PCI platform driver
>> [    2.047993] ehci-pci 0000:00:1d.7: EHCI Host Controller
>> [    2.053397] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
>> [    2.060906] ehci-pci 0000:00:1d.7: debug port 1
>> [    2.069457] ehci-pci 0000:00:1d.7: irq 16, io mem 0xf3304000
>> [    2.081017] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
>> [    2.086870] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    2.093721] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.101040] usb usb1: Product: EHCI Host Controller
>> [    2.105982] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
>> [    2.111790] usb usb1: SerialNumber: 0000:00:1d.7
>> [    2.116724] hub 1-0:1.0: USB hub found
>> [    2.120545] hub 1-0:1.0: 8 ports detected
>> [    2.124828] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    2.131174] uhci_hcd: USB Universal Host Controller Interface driver
>> [    2.137738] uhci_hcd 0000:00:1d.0: UHCI Host Controller
>> [    2.143141] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
>> [    2.150640] uhci_hcd 0000:00:1d.0: detected 2 ports
>> [    2.155615] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003000
>> [    2.161468] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.168319] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.175642] usb usb2: Product: UHCI Host Controller
>> [    2.180585] usb usb2: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.186394] usb usb2: SerialNumber: 0000:00:1d.0
>> [    2.191310] hub 2-0:1.0: USB hub found
>> [    2.195139] hub 2-0:1.0: 2 ports detected
>> [    2.199413] uhci_hcd 0000:00:1d.1: UHCI Host Controller
>> [    2.204827] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
>> [    2.212335] uhci_hcd 0000:00:1d.1: detected 2 ports
>> [    2.217305] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003020
>> [    2.223167] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.225037] ata5: SATA link down (SStatus 0 SControl 300)
>> [    2.225064] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.225087] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    2.225114] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.225133] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.225154] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.266626] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.273950] usb usb3: Product: UHCI Host Controller
>> [    2.278891] usb usb3: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.284700] usb usb3: SerialNumber: 0000:00:1d.1
>> [    2.289633] hub 3-0:1.0: USB hub found
>> [    2.293454] hub 3-0:1.0: 2 ports detected
>> [    2.297779] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> [    2.303174] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>> [    2.310668] uhci_hcd 0000:00:1d.2: detected 2 ports
>> [    2.315644] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
>> [    2.321502] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.328347] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.335661] usb usb4: Product: UHCI Host Controller
>> [    2.340597] usb usb4: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.346400] usb usb4: SerialNumber: 0000:00:1d.2
>> [    2.351290] hub 4-0:1.0: USB hub found
>> [    2.355110] hub 4-0:1.0: 2 ports detected
>> [    2.359378] uhci_hcd 0000:00:1d.3: UHCI Host Controller
>> [    2.364753] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
>> [    2.372252] uhci_hcd 0000:00:1d.3: detected 2 ports
>> [    2.377222] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003060
>> [    2.383074] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.389922] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.397238] usb usb5: Product: UHCI Host Controller
>> [    2.402182] usb usb5: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.407990] usb usb5: SerialNumber: 0000:00:1d.3
>> [    2.412895] hub 5-0:1.0: USB hub found
>> [    2.417495] hub 5-0:1.0: 2 ports detected
>> [    2.421795] usbcore: registered new interface driver usblp
>> [    2.427343] Initializing USB Mass Storage driver...
>> [    2.432364] usbcore: registered new interface driver usb-storage
>> [    2.438432] USB Mass Storage support registered.
>> [    2.443290] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
>> [    2.576017] tsc: Refined TSC clocksource calibration: 2333.415 MHz
>> [    2.582266] Switching to clocksource tsc
>> [    2.646010] usb 2-2: new low-speed USB device number 2 using uhci_hcd
>> [    2.703408] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    2.708661] mousedev: PS/2 mouse device common for all mice
>> [    2.714692] rtc_cmos 00:03: RTC can wake from S4
>> [    2.719565] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>> [    2.725739] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
>> [    2.733627] md: linear personality registered for level -1
>> [    2.739179] md: raid0 personality registered for level 0
>> [    2.744548] md: raid1 personality registered for level 1
>> [    2.749916] md: raid10 personality registered for level 10
>> [    2.755458] md: raid6 personality registered for level 6
>> [    2.760824] md: raid5 personality registered for level 5
>> [    2.766192] md: raid4 personality registered for level 4
>> [    2.771822] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
>> [    2.780505] device-mapper: raid: Loading target version 1.4.2
>> [    2.786410] device-mapper: cache-policy-mq: version 1.0.0 loaded
>> [    2.792475] device-mapper: cache cleaner: version 1.0.0 loaded
>> [    2.798363] cpuidle: using governor ladder
>> [    2.802517] cpuidle: using governor menu
>> [    2.806498] EFI Variables Facility v0.08 2004-May-17
>> [    2.811651] hidraw: raw HID events driver (C) Jiri Kosina
>> [    2.818589] usbcore: registered new interface driver usbhid
>> [    2.824220] usbhid: USB HID core driver
>> [    5.842007] hda-intel 0000:00:1b.0: azx_get_response timeout, switching to polling mode: last cmd=0x000f0000
>> [    6.852006] hda-intel 0000:00:1b.0: No response from codec, disabling MSI: last cmd=0x000f0000
>> [    7.225015] ata3.00: qc timeout (cmd 0xec)
>> [    7.229177] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [    7.235334] ata4.00: qc timeout (cmd 0xec)
>> [    7.239496] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [    7.245652] ata1.00: qc timeout (cmd 0xec)
>> [    7.249813] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [    7.255970] ata2.00: qc timeout (cmd 0xa1)
>> [    7.260136] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [    7.266300] ata6.00: qc timeout (cmd 0xec)
>> [    7.270465] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [    7.558019] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.570023] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.582019] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    7.588277] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.594529] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.861006] hda-intel 0000:00:1b.0: Codec #0 probe error; disabling it...
>> [    8.873006] hda_intel: azx_get_response timeout, switching to single_cmd mode: last cmd=0x000f0000
>> [    8.885125] hda_codec: ALC262: SKU not ready 0x411111f0
>> [    8.902602] Netfilter messages via NETLINK v0.30.
>> [    8.907378] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>> [    8.913711] ctnetlink v0.93: registering with nfnetlink.
>> [    8.919199] ip_tables: (C) 2000-2006 Netfilter Core Team
>> [    8.924605] TCP: cubic registered
>> [    8.927982] Initializing XFRM netlink socket
>> [    8.932728] NET: Registered protocol family 10
>> [    8.937542] ip6_tables: (C) 2000-2006 Netfilter Core Team
>> [    8.943061] sit: IPv6 over IPv4 tunneling driver
>> [    8.948056] NET: Registered protocol family 17
>> [    8.952588] Key type dns_resolver registered
>> [    8.957700] Loading module verification certificates
>> [    8.963791] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 0c33cdda5e831cd8c069c7b17dc72268cc6fc0e7'
>> [    8.973628] registered taskstats version 1
>> [    8.979508] Key type encrypted registered
>> [    8.985276] IMA: No TPM chip found, activating TPM-bypass!
>> [    8.993723]   Magic number: 5:775:579
>> [    8.997497] mem kmem: hash matches
>> [    9.000970] pci_bus 0000:00: hash matches
>> [    9.005070] console [netcon0] enabled
>> [    9.008792] netconsole: network logging started
>> [    9.098143] ALSA device list:
>> [    9.101179]   #0: HDA Intel at 0xf3300000 irq 65
>> [   17.564011] ata4.00: qc timeout (cmd 0xec)
>> [   17.568179] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.574339] ata4: limiting SATA link speed to 1.5 Gbps
>> [   17.579549] ata1.00: qc timeout (cmd 0xec)
>> [   17.583716] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.589864] ata1: limiting SATA link speed to 1.5 Gbps
>> [   17.595070] ata2.00: qc timeout (cmd 0xa1)
>> [   17.599231] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.605379] ata2: limiting SATA link speed to 1.5 Gbps
>> [   17.610593] ata6.00: qc timeout (cmd 0xec)
>> [   17.614760] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.620908] ata6: limiting SATA link speed to 1.5 Gbps
>> [   17.626120] ata3.00: qc timeout (cmd 0xec)
>> [   17.630280] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   17.636427] ata3: limiting SATA link speed to 1.5 Gbps
>> [   17.913016] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.919279] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.931019] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.943016] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   17.949275] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   47.919011] ata4.00: qc timeout (cmd 0xec)
>> [   47.923177] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   47.929338] ata1.00: qc timeout (cmd 0xec)
>> [   47.933503] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   47.939658] ata2.00: qc timeout (cmd 0xa1)
>> [   47.943824] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   47.949980] ata6.00: qc timeout (cmd 0xec)
>> [   47.954159] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   47.960318] ata3.00: qc timeout (cmd 0xec)
>> [   47.964483] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> [   48.242017] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   48.254021] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   48.266018] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   48.272272] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   48.278529] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> [   48.286162] Freeing unused kernel memory: 1160k freed
>> [   48.291702] Write protecting the kernel read-only data: 14336k
>> [   48.302132] Freeing unused kernel memory: 1456k freed
>> [   48.309312] Freeing unused kernel memory: 504k freed
>> [   48.345557] dracut: dracut-009-12.fc15
>> [   48.360229] udev[1113]: starting version 167
>> [   48.438175] dracut: Starting plymouth daemon
>> [   48.468363] Floppy drive(s): fd0 is 1.44M
>> [   51.488031] floppy0: no floppy controllers found
>>
>>
>> First kernel boot logs
>> =======================
>>
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.9.0-rc1+ (<edited>) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #168 SMP Fri Mar 8 11:26:01 EST 2013
>> [    0.000000] Command line: ro root=UUID=90e92cac-8f9b-464d-9e00-11491cc4bf8e rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=tty0 console=ttyS0,115200n8 console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000097000-0x000000000009ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffc283f] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000bffc2840-0x00000000bfffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] SMBIOS 2.5 present.
>> [    0.000000] No AGP bridge found
>> [    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] e820: last_pfn = 0xbffc2 max_arch_pfn = 0x400000000
>> [    0.000000] found SMP MP-table at [mem 0x000fe700-0x000fe70f] mapped at [ffff8800000fe700]
>> [    0.000000] Scanning 1 areas for low memory corruption
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> [    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
>> [    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
>> [    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
>> [    0.000000] init_memory_mapping: [mem 0x00100000-0xbffc1fff]
>> [    0.000000] RAMDISK: [mem 0x37b7b000-0x37feffff]
>> [    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System RAM: 4095MB)
>> [    0.000000] ACPI: RSDP 00000000000e9810 00024 (v02 HPQOEM)
>> [    0.000000] ACPI: XSDT 00000000bffc52ec 0006C (v01 HPQOEM SLIC-WKS 20070918      00000000)
>> [    0.000000] ACPI: FACP 00000000bffc5494 000F4 (v03 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI BIOS Bug: Error: 32/64X address mismatch in FADT/Gpe0Block: 0x0000F828/0x000000000001F030, using 32 (20130117/tbfadt-462)
>> [    0.000000] ACPI: DSDT 00000000bffc5a6e 02697 (v01 HPQOEM     DSDT 00000001 MSFT 0100000E)
>> [    0.000000] ACPI: FACS 00000000bffc5200 00040
>> [    0.000000] ACPI: SSDT 00000000bffc8105 06A92 (v01 HPQOEM  PROJECT 00000001 MSFT 0100000E)
>> [    0.000000] ACPI: APIC 00000000bffc5588 000C8 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: ASF! 00000000bffc5650 0006A (v32 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: MCFG 00000000bffc5852 0003C (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: SLIC 00000000bffc588e 00176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
>> [    0.000000] ACPI: HPET 00000000bffc5a04 00038 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: TCPA 00000000bffc5a3c 00032 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] ACPI: DMAR 00000000bffc56ba 00108 (v01 HPQOEM SEABURG  00000001      00000000)
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
>> [    0.000000]   NODE_DATA [mem 0x13fff9000-0x13fffcfff]
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>> [    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x00001000-0x00096fff]
>> [    0.000000]   node   0: [mem 0x00100000-0xbffc1fff]
>> [    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
>> [    0.000000] ACPI: PM-Timer IO Port: 0xf808
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
>> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
>> [    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec89000, GSI 24-47
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
>> [    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
>> [    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
>> [    0.000000] PM: Registered nosave memory: 00000000bffc2000 - 00000000bffc3000
>> [    0.000000] PM: Registered nosave memory: 00000000bffc3000 - 00000000c0000000
>> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
>> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
>> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
>> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
>> [    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
>> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013fc00000 s80000 r8192 d22400 u262144
>> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032002
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: ro root=UUID=90e92cac-8f9b-464d-9e00-11491cc4bf8e rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=tty0 console=ttyS0,115200n8 console=ttyS0,115200n8 selinux=0 crashkernel=128M@64M
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] __ex_table already sorted, skipping sort
>> [    0.000000] Checking aperture...
>> [    0.000000] No AGP bridge found
>> [    0.000000] Memory: 3907908k/5242880k available (8771k kernel code, 1049248k absent, 285724k reserved, 6390k data, 1160k init)
>> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
>> [    0.000000] NR_IRQS:4352 nr_irqs:1152 16
>> [    0.000000] Console: colour VGA+ 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] console [ttyS0] enabled
>> [    0.000000] tsc: Fast TSC calibration using PIT
>> [    0.000000] tsc: Detected 2333.444 MHz processor
>> [    0.002004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4666.88 BogoMIPS (lpj=2333444)
>> [    0.004003] pid_max: default: 32768 minimum: 301
>> [    0.005037] Security Framework initialized
>> [    0.006007] SELinux:  Disabled at boot.
>> [    0.007306] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> [    0.010580] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>> [    0.012523] Mount-cache hash table entries: 256
>> [    0.013272] Initializing cgroup subsys cpuacct
>> [    0.014004] Initializing cgroup subsys freezer
>> [    0.015003] Initializing cgroup subsys blkio
>> [    0.016041] CPU: Physical Processor ID: 0
>> [    0.017002] CPU: Processor Core ID: 0
>> [    0.018003] mce: CPU supports 6 MCE banks
>> [    0.019009] CPU0: Thermal monitoring enabled (TM2)
>> [    0.020008] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
>> [    0.020008] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
>> [    0.020008] tlb_flushall_shift: -1
>> [    0.021106] Freeing SMP alternatives: 28k freed
>> [    0.022017] ACPI: Core revision 20130117
>> [    0.025989] ACPI: All ACPI Tables successfully acquired
>> [    0.028007] ftrace: allocating 30474 entries in 120 pages
>> [    0.037562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.048659] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.33GHz (fam: 06, model: 17, stepping: 04)
>> [    0.053000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
>> [    0.057002] ... version:                2
>> [    0.058001] ... bit width:              40
>> [    0.059001] ... generic registers:      2
>> [    0.060001] ... value mask:             000000ffffffffff
>> [    0.061001] ... max period:             000000007fffffff
>> [    0.062001] ... fixed-purpose events:   3
>> [    0.063001] ... event mask:             0000000700000003
>> [    0.065120] smpboot: Booting Node   0, Processors  #1 #2 #3
>> [    0.104014] Brought up 4 CPUs
>> [    0.105002] smpboot: Total of 4 processors activated (18667.55 BogoMIPS)
>> [    0.108341] EVM: security.selinux
>> [    0.109008] EVM: security.ima
>> [    0.110003] EVM: security.capability
>> [    0.111316] xor: measuring software checksum speed
>> [    0.122002]    prefetch64-sse: 10028.000 MB/sec
>> [    0.133002]    generic_sse:  8864.000 MB/sec
>> [    0.134001] xor: using function: prefetch64-sse (10028.000 MB/sec)
>> [    0.135021] RTC time: 12:05:42, date: 03/08/13
>> [    0.136061] NET: Registered protocol family 16
>> [    0.138111] ACPI: bus type PCI registered
>> [    0.139031] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.140007] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
>> [    0.157009] PCI: Using configuration type 1 for base access
>> [    0.174040] bio: create slab<bio-0>  at 0
>> [    0.194294] raid6: sse2x1    3265 MB/s
>> [    0.214301] raid6: sse2x2    5906 MB/s
>> [    0.234300] raid6: sse2x4    6492 MB/s
>> [    0.238002] raid6: using algorithm sse2x4 (6492 MB/s)
>> [    0.243002] raid6: using ssse3x2 recovery algorithm
>> [    0.248018] ACPI: Added _OSI(Module Device)
>> [    0.253003] ACPI: Added _OSI(Processor Device)
>> [    0.257002] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.262002] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.280016] ACPI: SSDT 00000000bffd07c1 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
>> [    0.288577] ACPI: Dynamic OEM Table Load:
>> [    0.293254] ACPI: SSDT           (null) 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
>> [    0.307302] ACPI: Interpreter enabled
>> [    0.311007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
>> [    0.321002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
>> [    0.330010] ACPI: (supports S0 S3 S4 S5)
>> [    0.334002] ACPI: Using IOAPIC for interrupt routing
>> [    0.339026] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
>> [    0.365037] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.371050] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20130117/dsfield-211)
>> [    0.381002] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88013aa61c30), AE_ALREADY_EXISTS (20130117/psparse-537)
>> [    0.393003] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
>> [    0.401045] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20130117/dsfield-211)
>> [    0.410002] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88013aa61c30), AE_ALREADY_EXISTS (20130117/psparse-537)
>> [    0.423006] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [    0.431002] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
>> [    0.439135] PCI host bridge to bus 0000:00
>> [    0.443005] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.449003] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
>> [    0.455002] pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffffff]
>> [    0.462144] pci 0000:00:01.0: System wakeup disabled by ACPI
>> [    0.468096] pci 0000:00:05.0: System wakeup disabled by ACPI
>> [    0.474098] pci 0000:00:09.0: System wakeup disabled by ACPI
>> [    0.482195] pci 0000:00:1c.0: System wakeup disabled by ACPI
>> [    0.488116] pci 0000:00:1d.0: System wakeup disabled by ACPI
>> [    0.494113] pci 0000:00:1d.1: System wakeup disabled by ACPI
>> [    0.499116] pci 0000:00:1d.2: System wakeup disabled by ACPI
>> [    0.505112] pci 0000:00:1d.3: System wakeup disabled by ACPI
>> [    0.511173] pci 0000:00:1d.7: System wakeup disabled by ACPI
>> [    0.517091] pci 0000:00:1e.0: System wakeup disabled by ACPI
>> [    0.524065] pci 0000:00:01.0: PCI bridge to [bus 80]
>> [    0.529135] pci 0000:60:00.0: System wakeup disabled by ACPI
>> [    0.537013] pci 0000:00:05.0: PCI bridge to [bus 60]
>> [    0.553008] pci 0000:00:09.0: PCI bridge to [bus 10-40]
>> [    0.563972] pci 0000:1e:00.0: System wakeup disabled by ACPI
>> [    0.574013] pci 0000:1e:01.0: System wakeup disabled by ACPI
>> [    0.581138] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
>> [    0.589039] pci 0000:1e:00.0: PCI bridge to [bus 20]
>> [    0.600285] pci 0000:40:00.0: System wakeup disabled by ACPI
>> [    0.606287] pci 0000:1e:01.0: PCI bridge to [bus 40]
>> [    0.615184] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
>> [    0.622252] pci 0000:0e:00.0: System wakeup disabled by ACPI
>> [    0.630015] pci 0000:00:1c.0: PCI bridge to [bus 0e]
>> [    0.635048] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
>> [    0.642032] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [    0.648323] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15)
>> [    0.655740] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
>> [    0.663307] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
>> [    0.670436] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
>> [    0.678054] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
>> [    0.687307] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15)
>> [    0.694038] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 14 15)
>> [    0.701306] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
>> [    0.711086] ACPI: No dock devices found.
>> [    0.715030] vgaarb: device added: PCI:0000:60:00.0,decodes=io+mem,owns=io+mem,locks=none
>> [    0.723006] vgaarb: loaded
>> [    0.726002] vgaarb: bridge control possible 0000:60:00.0
>> [    0.731071] SCSI subsystem initialized
>> [    0.735004] ACPI: bus type ATA registered
>> [    0.739034] ACPI: bus type USB registered
>> [    0.744031] usbcore: registered new interface driver usbfs
>> [    0.749022] usbcore: registered new interface driver hub
>> [    0.755017] usbcore: registered new device driver usb
>> [    0.760031] pps_core: LinuxPPS API ver. 1 registered
>> [    0.765002] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti<giometti@linux.it>
>> [    0.774017] PTP clock support registered
>> [    0.779019] Advanced Linux Sound Architecture Driver Initialized.
>> [    0.785003] PCI: Using ACPI for IRQ routing
>> [    0.837065] cfg80211: Calling CRDA to update world regulatory domain
>> [    0.838144] NetLabel: Initializing
>> [    0.838146] NetLabel:  domain hash size = 128
>> [    0.838146] NetLabel:  protocols = UNLABELED CIPSOv4
>> [    0.838199] NetLabel:  unlabeled traffic allowed by default
>> [    0.838233] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
>> [    0.838233] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> [    0.838233] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> [    0.880062] Switching to clocksource hpet
>> [    0.891484] pnp: PnP ACPI init
>> [    0.894615] ACPI: bus type PNP registered
>> [    0.900401] system 00:0b: [io  0x04d0-0x04d1] has been reserved
>> [    0.906523] system 00:0c: [io  0x0400-0x041f] has been reserved
>> [    0.912506] system 00:0c: [io  0x0420-0x043f] has been reserved
>> [    0.918486] system 00:0c: [io  0x0440-0x045f] has been reserved
>> [    0.924466] system 00:0c: [io  0x0460-0x047f] has been reserved
>> [    0.930444] system 00:0c: [io  0x0480-0x048f] has been reserved
>> [    0.936424] system 00:0c: [io  0x0490-0x049f] has been reserved
>> [    0.942404] system 00:0c: [io  0xf800-0xf81f] has been reserved
>> [    0.948383] system 00:0c: [io  0xf820-0xf83f] has been reserved
>> [    0.954361] system 00:0c: [io  0xf840-0xf85f] has been reserved
>> [    0.960341] system 00:0c: [io  0xf860-0xf87f] has been reserved
>> [    0.966321] system 00:0c: [io  0xfa00-0xfa3f] has been reserved
>> [    0.972301] system 00:0c: [io  0xfc00-0xfc7f] has been reserved
>> [    0.978282] system 00:0c: [io  0xfc80-0xfcff] has been reserved
>> [    0.984259] system 00:0c: [io  0xfe00-0xfe7f] has been reserved
>> [    0.990239] system 00:0c: [io  0xfe80-0xfeff] has been reserved
>> [    0.996323] system 00:0d: [mem 0xfed1c000-0xfed1ffff] has been reserved
>> [    1.002996] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
>> [    1.009670] system 00:0d: [mem 0xfee00000-0xfeefffff] has been reserved
>> [    1.016343] system 00:0d: [mem 0xfe700000-0xfe7003ff] has been reserved
>> [    1.023014] system 00:0d: [mem 0xfe600000-0xfe6fffff] has been reserved
>> [    1.029687] system 00:0d: [mem 0xfe000000-0xfe01ffff] has been reserved
>> [    1.036636] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
>> [    1.043657] system 00:0e: [mem 0x000c0000-0x000e7fff] could not be reserved
>> [    1.050677] system 00:0e: [mem 0x000e8000-0x000effff] could not be reserved
>> [    1.057695] system 00:0e: [mem 0x000f0000-0x000fffff] could not be reserved
>> [    1.064714] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
>> [    1.071733] system 00:0e: [mem 0xfeda0000-0xfedbffff] has been reserved
>> [    1.078538] system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
>> [    1.085235] pnp: PnP ACPI: found 16 devices
>> [    1.089480] ACPI: bus type PNP unregistered
>> [    1.105073] pci 0000:00:09.0: BAR 15: assigned [mem 0xf3400000-0xf34fffff pref]
>> [    1.112477] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf3500000-0xf36fffff 64bit pref]
>> [    1.120399] pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
>> [    1.126638] pci 0000:00:01.0: PCI bridge to [bus 80]
>> [    1.131673] pci 0000:60:00.0: BAR 6: can't assign mem pref (size 0x20000)
>> [    1.138520] pci 0000:00:05.0: PCI bridge to [bus 60]
>> [    1.143546] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
>> [    1.149701] pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
>> [    1.156548] pci 0000:00:05.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
>> [    1.164388] pci 0000:10:00.0: BAR 15: assigned [mem 0xf3400000-0xf34fffff pref]
>> [    1.171790] pci 0000:1e:01.0: BAR 15: assigned [mem 0xf3400000-0xf34fffff pref]
>> [    1.179201] pci 0000:1e:00.0: PCI bridge to [bus 20]
>> [    1.184599] pci 0000:40:00.0: BAR 6: assigned [mem 0xf3400000-0xf347ffff pref]
>> [    1.191916] pci 0000:1e:01.0: PCI bridge to [bus 40]
>> [    1.196942] pci 0000:1e:01.0:   bridge window [io  0x2000-0x2fff]
>> [    1.203188] pci 0000:1e:01.0:   bridge window [mem 0xf3100000-0xf31fffff]
>> [    1.210080] pci 0000:1e:01.0:   bridge window [mem 0xf3400000-0xf34fffff pref]
>> [    1.217538] pci 0000:10:00.0: PCI bridge to [bus 1e-40]
>> [    1.222825] pci 0000:10:00.0:   bridge window [io  0x2000-0x2fff]
>> [    1.229068] pci 0000:10:00.0:   bridge window [mem 0xf3100000-0xf31fffff]
>> [    1.235960] pci 0000:10:00.0:   bridge window [mem 0xf3400000-0xf34fffff pref]
>> [    1.243414] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
>> [    1.249071] pci 0000:00:09.0: PCI bridge to [bus 10-40]
>> [    1.254357] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
>> [    1.260512] pci 0000:00:09.0:   bridge window [mem 0xf3100000-0xf32fffff]
>> [    1.267358] pci 0000:00:09.0:   bridge window [mem 0xf3400000-0xf34fffff pref]
>> [    1.275456] pci 0000:00:1c.0: PCI bridge to [bus 0e]
>> [    1.280481] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
>> [    1.286635] pci 0000:00:1c.0:   bridge window [mem 0xf3000000-0xf30fffff]
>> [    1.293480] pci 0000:00:1c.0:   bridge window [mem 0xf3500000-0xf36fffff 64bit pref]
>> [    1.301319] pci 0000:00:1e.0: PCI bridge to [bus 01]
>> [    1.307684] NET: Registered protocol family 2
>> [    1.312343] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
>> [    1.319981] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
>> [    1.327193] TCP: Hash tables configured (established 32768 bind 32768)
>> [    1.333823] TCP: reno registered
>> [    1.337140] UDP hash table entries: 2048 (order: 5, 196608 bytes)
>> [    1.343397] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
>> [    1.350165] NET: Registered protocol family 1
>> [    1.354675] RPC: Registered named UNIX socket transport module.
>> [    1.360658] RPC: Registered udp transport module.
>> [    1.365424] RPC: Registered tcp transport module.
>> [    1.370198] RPC: Registered tcp NFSv4.1 backchannel transport module.
>> [    1.378249] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
>> [    1.384770] Trying to unpack rootfs image as initramfs...
>> [    1.488303] Freeing initrd memory: 4564k freed
>> [    1.494472] dmar: Host address width 36
>> [    1.498377] dmar: DRHD base: 0x000000fe710000 flags: 0x0
>> [    1.503771] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.511610] dmar: DRHD base: 0x000000fe714000 flags: 0x0
>> [    1.516989] dmar: IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.524825] dmar: DRHD base: 0x000000fe719000 flags: 0x0
>> [    1.530203] dmar: IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.538041] dmar: DRHD base: 0x000000fe718000 flags: 0x1
>> [    1.543416] dmar: IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900800c2f0462 ecap e01
>> [    1.551253] dmar: RMRR base: 0x000000bffd3000 end: 0x000000bffd3fff
>> [    1.557581] dmar: RMRR base: 0x000000bffd4000 end: 0x000000bffd4fff
>> [    1.563906] dmar: RMRR base: 0x000000bffd5000 end: 0x000000bffd5fff
>> [    1.570239] dmar: RMRR base: 0x000000bffd6000 end: 0x000000bffd6fff
>> [    1.576573] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    1.583073] software IO TLB [mem 0xbbfc2000-0xbffc2000] (64MB) mapped at [ffff8800bbfc2000-ffff8800bffc1fff]
>> [    1.594127] microcode: CPU0 sig=0x10674, pf=0x40, revision=0x404
>> [    1.600197] microcode: CPU1 sig=0x10674, pf=0x40, revision=0x404
>> [    1.606273] microcode: CPU2 sig=0x10674, pf=0x40, revision=0x404
>> [    1.612346] microcode: CPU3 sig=0x10674, pf=0x40, revision=0x404
>> [    1.618480] microcode: Microcode Update Driver: v2.00<tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> [    1.627356] Scanning for low memory corruption every 60 seconds
>> [    1.633766] Initialise module verification
>> [    1.637995] audit: initializing netlink socket (disabled)
>> [    1.643474] type=2000 audit(1362744342.642:1): initialized
>> [    1.685785] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>> [    1.697995] VFS: Disk quotas dquot_6.5.2
>> [    1.702102] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    1.710463] NFS: Registering the id_resolver key type
>> [    1.715587] Key type id_resolver registered
>> [    1.719834] Key type id_legacy registered
>> [    1.723987] msgmni has been set to 7641
>> [    1.728562] Key type asymmetric registered
>> [    1.732724] Asymmetric key parser 'x509' registered
>> [    1.737815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
>> [    1.745346] io scheduler noop registered
>> [    1.749332] io scheduler deadline registered
>> [    1.753748] io scheduler cfq registered (default)
>> [    1.762984] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> [    1.768949] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
>> [    1.777396] ACPI: Power Button [PBTN]
>> [    1.781217] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    1.788708] ACPI: Power Button [PWRF]
>> [    1.792738] ACPI: Requesting acpi_cpufreq
>> [    1.799941] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    1.826858] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    1.833459] Non-volatile memory driver v1.3
>> [    1.837780] Linux agpgart interface v0.103
>> [    1.842296] [drm] Initialized drm 1.1.0 20060810
>> [    1.850225] brd: module loaded
>> [    1.855038] loop: module loaded
>> [    1.858926] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
>> [    1.867199] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
>> [    1.875136] scsi0 : ahci
>> [    1.877936] scsi1 : ahci
>> [    1.880722] scsi2 : ahci
>> [    1.883506] scsi3 : ahci
>> [    1.886289] scsi4 : ahci
>> [    1.889088] scsi5 : ahci
>> [    1.891835] ata1: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304500 irq 19
>> [    1.899332] ata2: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304580 irq 19
>> [    1.906822] ata3: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304600 irq 19
>> [    1.914311] ata4: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304680 irq 19
>> [    1.921800] ata5: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304700 irq 19
>> [    1.929289] ata6: SATA max UDMA/133 abar m1024@0xf3304400 port 0xf3304780 irq 19
>> [    1.937966] scsi6 : ata_piix
>> [    1.941104] scsi7 : ata_piix
>> [    1.944181] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30c0 irq 14
>> [    1.951211] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30c8 irq 15
>> [    1.958744] tg3.c:v3.130 (February 14, 2013)
>> [    1.974267] tg3 0000:0e:00.0 eth0: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:19:bb:ea:3c:7d
>> [    1.984617] tg3 0000:0e:00.0 eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
>> [    1.994444] tg3 0000:0e:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
>> [    2.002365] tg3 0000:0e:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
>> [    2.009235] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
>> [    2.015388] e100: Copyright(c) 1999-2006 Intel Corporation
>> [    2.021010] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
>> [    2.028114] e1000: Copyright (c) 1999-2006 Intel Corporation.
>> [    2.033988] sky2: driver version 1.30
>> [    2.038174] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    2.044770] ehci-pci: EHCI PCI platform driver
>> [    2.049448] ehci-pci 0000:00:1d.7: EHCI Host Controller
>> [    2.054819] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
>> [    2.062320] ehci-pci 0000:00:1d.7: debug port 1
>> [    2.070870] ehci-pci 0000:00:1d.7: irq 16, io mem 0xf3304000
>> [    2.082016] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
>> [    2.087886] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    2.094733] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.102050] usb usb1: Product: EHCI Host Controller
>> [    2.106991] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
>> [    2.112797] usb usb1: SerialNumber: 0000:00:1d.7
>> [    2.117684] hub 1-0:1.0: USB hub found
>> [    2.121512] hub 1-0:1.0: 8 ports detected
>> [    2.125775] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    2.132089] uhci_hcd: USB Universal Host Controller Interface driver
>> [    2.138665] uhci_hcd 0000:00:1d.0: UHCI Host Controller
>> [    2.144046] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
>> [    2.151541] uhci_hcd 0000:00:1d.0: detected 2 ports
>> [    2.156505] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003000
>> [    2.162353] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.169210] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.176525] usb usb2: Product: UHCI Host Controller
>> [    2.181463] usb usb2: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.187267] usb usb2: SerialNumber: 0000:00:1d.0
>> [    2.192141] hub 2-0:1.0: USB hub found
>> [    2.195963] hub 2-0:1.0: 2 ports detected
>> [    2.200259] uhci_hcd 0000:00:1d.1: UHCI Host Controller
>> [    2.205638] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
>> [    2.213139] uhci_hcd 0000:00:1d.1: detected 2 ports
>> [    2.218103] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003020
>> [    2.223961] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.230811] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.238127] usb usb3: Product: UHCI Host Controller
>> [    2.241037] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.241062] ata5: SATA link down (SStatus 0 SControl 300)
>> [    2.241089] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    2.241110] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.241141] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.241162] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.241345] ata4.00: ATA-7: INTEL SSDSA2MH080G1GN, 045C8820, max UDMA/133
>> [    2.241347] ata4.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 31)
>> [    2.293033] usb usb3: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.293046] ata2.00: ATAPI: HL-DT-STDVD-ROM GDRH10N, D70D, max UDMA/100
>> [    2.293090] ata4.00: configured for UDMA/133
>> [    2.293164] ata3.00: ATA-8: WDC SSC-D0064SC-2100, 5.12, max UDMA/133
>> [    2.293166] ata3.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> [    2.323437] ata1.00: ATA-7: Hitachi HDS721680PLA380, P21OAB6A, max UDMA/100
>> [    2.323439] usb usb3: SerialNumber: 0000:00:1d.1
>> [    2.326166] hub 3-0:1.0: USB hub found
>> [    2.326171] hub 3-0:1.0: 2 ports detected
>> [    2.326392] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> [    2.326455] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>> [    2.326463] uhci_hcd 0000:00:1d.2: detected 2 ports
>> [    2.326501] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
>> [    2.326544] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.326546] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.326548] usb usb4: Product: UHCI Host Controller
>> [    2.326550] usb usb4: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.326551] usb usb4: SerialNumber: 0000:00:1d.2
>> [    2.326698] hub 4-0:1.0: USB hub found
>> [    2.326702] hub 4-0:1.0: 2 ports detected
>> [    2.326921] uhci_hcd 0000:00:1d.3: UHCI Host Controller
>> [    2.326985] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
>> [    2.326993] uhci_hcd 0000:00:1d.3: detected 2 ports
>> [    2.327040] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003060
>> [    2.327085] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.327087] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.327088] usb usb5: Product: UHCI Host Controller
>> [    2.327090] usb usb5: Manufacturer: Linux 3.9.0-rc1+ uhci_hcd
>> [    2.327092] usb usb5: SerialNumber: 0000:00:1d.3
>> [    2.327248] hub 5-0:1.0: USB hub found
>> [    2.327252] hub 5-0:1.0: 2 ports detected
>> [    2.327425] usbcore: registered new interface driver usblp
>> [    2.327426] Initializing USB Mass Storage driver...
>> [    2.327485] usbcore: registered new interface driver usb-storage
>> [    2.327485] USB Mass Storage support registered.
>> [    2.327607] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
>> [    2.494978] ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>> [    2.496040] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    2.496046] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    2.496163] mousedev: PS/2 mouse device common for all mice
>> [    2.496452] rtc_cmos 00:03: RTC can wake from S4
>> [    2.496633] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>> [    2.496666] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
>> [    2.496772] md: linear personality registered for level -1
>> [    2.496773] md: raid0 personality registered for level 0
>> [    2.496774] md: raid1 personality registered for level 1
>> [    2.496776] md: raid10 personality registered for level 10
>> [    2.496776] md: raid6 personality registered for level 6
>> [    2.496777] md: raid5 personality registered for level 5
>> [    2.496778] md: raid4 personality registered for level 4
>> [    2.496997] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
>> [    2.497123] device-mapper: raid: Loading target version 1.4.2
>> [    2.497200] device-mapper: cache-policy-mq: version 1.0.0 loaded
>> [    2.497201] device-mapper: cache cleaner: version 1.0.0 loaded
>> [    2.497206] cpuidle: using governor ladder
>> [    2.497207] cpuidle: using governor menu
>> [    2.497208] EFI Variables Facility v0.08 2004-May-17
>> [    2.497309] hidraw: raw HID events driver (C) Jiri Kosina
>> [    2.498363] usbcore: registered new interface driver usbhid
>> [    2.498364] usbhid: USB HID core driver
>> [    2.596019] tsc: Refined TSC clocksource calibration: 2333.415 MHz
>> [    2.596023] Switching to clocksource tsc
>> [    2.638906] ata6.00: ATA-8: WDC WD30EZRS-00J99B0, 80.00A80, max UDMA/133
>> [    2.645669] ata6.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
>> [    2.652890] ata2.00: configured for UDMA/100
>> [    2.657330] ata3.00: configured for UDMA/133
>> [    2.661686] ata1.00: configured for UDMA/100
>> [    2.666096] ata6.00: configured for UDMA/133
>> [    2.666184] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72168 P21O PQ: 0 ANSI: 5
>> [    2.666514] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
>> [    2.666575] sd 0:0:0:0: [sda] Write Protect is off
>> [    2.666581] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    2.666605] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    2.689011] usb 2-2: new low-speed USB device number 2 using uhci_hcd
>> [    2.700212]  sda: sda1 sda2 sda3
>> [    2.700648] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    2.724733] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDRH10N  D70D PQ: 0 ANSI: 5
>> [    2.733095] hda_codec: ALC262: SKU not ready 0x411111f0
>> [    2.741643] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
>> [    2.747887] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    2.753422] sr 1:0:0:0: Attached scsi generic sg1 type 5
>> [    2.758971] scsi 2:0:0:0: Direct-Access     ATA      WDC SSC-D0064SC- 5.12 PQ: 0 ANSI: 5
>> [    2.767345] sd 2:0:0:0: [sdb] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
>> [    2.767427] sd 2:0:0:0: Attached scsi generic sg2 type 0
>> [    2.767587] scsi 3:0:0:0: Direct-Access     ATA      INTEL SSDSA2MH08 045C PQ: 0 ANSI: 5
>> [    2.767834] sd 3:0:0:0: [sdc] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
>> [    2.767880] sd 3:0:0:0: [sdc] Write Protect is off
>> [    2.767902] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    2.768035] sd 3:0:0:0: Attached scsi generic sg3 type 0
>> [    2.768542]  sdc: unknown partition table
>> [    2.777131] scsi 5:0:0:0: Direct-Access     ATA      WDC WD30EZRS-00J 80.0 PQ: 0 ANSI: 5
>> [    2.777188] sd 3:0:0:0: [sdc] Attached SCSI disk
>> [    2.777355] sd 5:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
>> [    2.777356] sd 5:0:0:0: [sdd] 4096-byte physical blocks
>> [    2.777402] sd 5:0:0:0: [sdd] Write Protect is off
>> [    2.777422] sd 5:0:0:0: Attached scsi generic sg4 type 0
>> [    2.777426] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    2.865121] sd 2:0:0:0: [sdb] Write Protect is off
>> [    2.870000] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    2.879855]  sdb: unknown partition table
>> [    2.884168] sd 2:0:0:0: [sdb] Attached SCSI disk
>> [    2.893513] Netfilter messages via NETLINK v0.30.
>> [    2.898322] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>> [    2.904652] ctnetlink v0.93: registering with nfnetlink.
>> [    2.910159] ip_tables: (C) 2000-2006 Netfilter Core Team
>> [    2.915563] TCP: cubic registered
>> [    2.918941] Initializing XFRM netlink socket
>> [    2.923659] NET: Registered protocol family 10
>> [    2.928506] ip6_tables: (C) 2000-2006 Netfilter Core Team
>> [    2.934027] sit: IPv6 over IPv4 tunneling driver
>> [    2.938992] NET: Registered protocol family 17
>> [    2.943537] Key type dns_resolver registered
>> [    2.948543] Loading module verification certificates
>> [    2.954847] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 0c33cdda5e831cd8c069c7b17dc72268cc6fc0e7'
>> [    2.964701] registered taskstats version 1
>> [    2.970797] Key type encrypted registered
>> [    2.976627] IMA: No TPM chip found, activating TPM-bypass!
>> [    2.984354] usb 2-2: New USB device found, idVendor=0624, idProduct=0291
>> [    2.985121]   Magic number: 5:366:76
>> [    2.994746] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [    2.994749] console [netcon0] enabled
>> [    2.994750] netconsole: network logging started
>> [    3.010237] usb 2-2: Product: Avocent AVRIQ-USB
>> [    3.014825] usb 2-2: Manufacturer: Avocent
>> [    3.053751] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
>> [    3.063985] hid-generic 0003:0624:0291.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-2/input0
>> [    3.104851] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input3
>> [    3.115119] hid-generic 0003:0624:0291.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-2/input1
>> [    3.162132] ALSA device list:
>> [    3.165166]   #0: HDA Intel at 0xf3300000 irq 65
>> [    3.201389]  sdd: sdd1 sdd2 sdd3
>> [    3.205088] sd 5:0:0:0: [sdd] Attached SCSI disk
>> [    3.211246] Freeing unused kernel memory: 1160k freed
>> [    3.216800] Write protecting the kernel read-only data: 14336k
>> [    3.227947] Freeing unused kernel memory: 1456k freed
>> [    3.235391] Freeing unused kernel memory: 504k freed
>> [    3.272271] dracut: dracut-009-12.fc15
>> [    3.287701] udev[1173]: starting version 167
>> [    3.320738] dracut: Starting plymouth daemon
>> [    3.353350] Floppy drive(s): fd0 is 1.44M
>> [    3.370234] FDC 0 is a post-1991 82077
>> [    3.691208] kjournald starting.  Commit interval 5 seconds
>> [    3.691272] EXT3-fs (sda2): mounted filesystem with writeback data mode
>> [    3.763581] dracut: Checking filesystems
>> [    3.767598] dracut: fsck -T -t noopts=_netdev -A -a
>> [    3.957734] dracut: /dev/sda2: Superblock last mount time is in the future. (by less than a day, probably due to the hardware clock being incorrectly set) FIXED. /dev/sda2: clean, 259572/4489216 files, 7067522/17929984 blocks
>> [    3.977995] dracut: Remounting /dev/disk/by-uuid/90e92cac-8f9b-464d-9e00-11491cc4bf8e with -o ro,
>> [    4.027270] kjournald starting.  Commit interval 5 seconds
>> [    4.027306] EXT3-fs (sda2): mounted filesystem with writeback data mode
>> [    4.066278] dracut: Mounted root filesystem /dev/sda2
>> [    4.207925] dracut: Switching root
>> [    4.999267] systemd[1]: systemd 26 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)

