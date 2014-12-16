Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaLPOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:46:17 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59842 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:46:15 -0500
Date: Tue, 16 Dec 2014 06:46:10 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216144610.GA1219@hudson.localdomain>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216142542.GC22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro,

On Tue, Dec 16, 2014 at 02:25:42PM +0000, Al Viro wrote:
> On Tue, Dec 16, 2014 at 06:09:52AM -0800, Jeremiah Mahler wrote:
> > >  		ramdisk_execute_command = NULL;
> > >  		prepare_namespace();
> > > +		{
> > > +		/* HACK */
> > > +			struct path old, new;
> > > +			get_fs_root(current->fs, &new);
> > > +			get_fs_root(&init_fs, &old);
> > > +			chroot_fs_refs(&old, &new);
> > > +			path_put(&old);
> > > +			path_put(&new);
> > > +		}
> > >  	}
> > >  
> > >  	/*
> > 
> > I tested the bad commit with your patch applied but it made no
> > difference, the wireless is still down.
> 
> Interesting...  What happens if you move that added piece (i.e. call of
> chroot_fs_refs()) just after that if, instead of the end of the body of
> the if?
> 
> > Not sure if it helps, but the dmesg is included below.  There are errors
> > about not being able to load the firmware that look interesting.
> 
> Errors about not being able to load the firmware clearly indicate that we
> have an attempt to load it (from a kernel thread of some sort, e.g.
> workqueue worker) getting failing with ENOENT.  So we have init_fs stuck
> behind, presumably still on initramfs under the overmounting rootfs.

Here is how I changed the code.

diff --git a/init/main.c b/init/main.c
index 36c29d6..961a8fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1026,16 +1026,17 @@ static noinline void __init kernel_init_freeable(void)
        if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
                ramdisk_execute_command = NULL;
                prepare_namespace();
-               {
-               /* HACK */
-                       struct path old, new;
-                       get_fs_root(current->fs, &new);
-                       get_fs_root(&init_fs, &old);
-                       chroot_fs_refs(&old, &new);
-                       path_put(&old);
-                       path_put(&new);
-               }
        }
+       {
+       /* HACK */
+               struct path old, new;
+               get_fs_root(current->fs, &new);
+               get_fs_root(&init_fs, &old);
+               chroot_fs_refs(&old, &new);
+               path_put(&old);
+               path_put(&new);
+       }
+
 
        /*
         * Ok, we have completed the initial bootup, and


And it still behaves the same.  Below is the dmesg output.


[    0.000000] CPU0 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc6+ (jeri@hudson) (gcc version 4.9.2 (Debian 4.9.2-7) ) #204 SMP Tue Dec 16 06:35:15 PST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.18.0-rc6+ root=UUID=ce693de1-b8f1-4176-9dda-e3afdbf43a6f ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000ced48fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ced49000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 3443CTO/3443CTO, BIOS G6ET59WW (2.03 ) 09/11/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x11e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F000000 mask FFF000000 uncachable
[    0.000000]   8 base 11E800000 mask FFF800000 uncachable
[    0.000000]   9 base 11E600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xced49 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b18000, 0x01b18fff] PGTABLE
[    0.000000] BRK [0x01b19000, 0x01b19fff] PGTABLE
[    0.000000] BRK [0x01b1a000, 0x01b1afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11e400000-0x11e5fffff]
[    0.000000]  [mem 0x11e400000-0x11e5fffff] page 2M
[    0.000000] BRK [0x01b1b000, 0x01b1bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11e3fffff]
[    0.000000]  [mem 0x11c000000-0x11e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01b1c000, 0x01b1cfff] PGTABLE
[    0.000000] BRK [0x01b1d000, 0x01b1dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xced48fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xcebfffff] page 2M
[    0.000000]  [mem 0xcec00000-0xced48fff] page 4k
[    0.000000] RAMDISK: [mem 0x35368000-0x369abfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0120 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000DAFFE170 0000CC (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: FACP 0x00000000DAFE7000 00010C (v05 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000DAFE9000 00FB6A (v01 LENOVO TP-G6    00002030 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000DAF5A000 000040
[    0.000000] ACPI: SLIC 0x00000000DAFFD000 000176 (v01 LENOVO TP-G6    00002030 PTL  00000001)
[    0.000000] ACPI: TCPA 0x00000000DAFFC000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 0x00000000DAFFB000 000408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFFA000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFF9000 000797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 0x00000000DAFE5000 000038 (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000DAFE4000 000098 (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000DAFE3000 00003C (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: ECDT 0x00000000DAFE2000 000052 (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: FPDT 0x00000000DAFE1000 000064 (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: ASF! 0x00000000DAFE8000 0000A5 (v32 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFE0000 00003E (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFDF000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: POAT 0x00000000DAFDE000 000055 (v03 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000DAFDD000 000C1A (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFDC000 000A7E (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 0x00000000DAFDB000 0000B8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000DAFDA000 0002A6 (v01 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000DAFD9000 000379 (v01 LENOVO AoacTabl 00001000 INTL 20061109)
[    0.000000] ACPI: DBG2 0x00000000DAFD8000 0000B4 (v00 LENOVO TP-G6    00002030 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011e5fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11e5f8000-0x11e5fcfff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011a000000-ffff88011d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xced48fff]
[    0.000000]   node   0: [mem 0x100000000-0x11e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x11e5fffff]
[    0.000000] On node 0 totalpages: 970980
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11520 pages used for memmap
[    0.000000]   DMA32 zone: 842568 pages, LIFO batch:31
[    0.000000]   Normal zone: 1701 pages used for memmap
[    0.000000]   Normal zone: 124416 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xced49000-0xdae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdafff000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88011e200000 s83648 r8192 d31040 u262144
[    0.000000] pcpu-alloc: s83648 r8192 d31040 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 957682
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.18.0-rc6+ root=UUID=ce693de1-b8f1-4176-9dda-e3afdbf43a6f ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3726868K/3883920K available (5319K kernel code, 1043K rwdata, 1816K rodata, 1212K init, 880K bss, 157052K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:33024 nr_irqs:488 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2494.291 MHz processor
[    0.000044] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.58 BogoMIPS (lpj=9977164)
[    0.000048] pid_max: default: 32768 minimum: 301
[    0.000058] ACPI: Core revision 20140926
[    0.016123] ACPI: All ACPI Tables successfully acquired
[    0.017154] Security Framework initialized
[    0.017163] AppArmor: AppArmor disabled by boot time parameter
[    0.017164] Yama: becoming mindful.
[    0.017483] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.018771] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.019351] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.019359] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.019622] Initializing cgroup subsys devices
[    0.019626] Initializing cgroup subsys freezer
[    0.019629] Initializing cgroup subsys net_cls
[    0.019632] Initializing cgroup subsys blkio
[    0.019634] Initializing cgroup subsys perf_event
[    0.019638] Initializing cgroup subsys net_prio
[    0.019671] CPU: Physical Processor ID: 0
[    0.019672] CPU: Processor Core ID: 0
[    0.019678] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.020166] mce: CPU supports 7 MCE banks
[    0.020179] CPU0: Thermal monitoring enabled (TM1)
[    0.020189] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.020323] Freeing SMP alternatives memory: 20K (ffffffff81a35000 - ffffffff81a3a000)
[    0.021371] ftrace: allocating 21491 entries in 84 pages
[    0.032662] dmar: Host address width 36
[    0.032664] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.032671] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.032673] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.032677] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.032679] dmar: RMRR base: 0x000000da3ba000 end: 0x000000da3d0fff
[    0.032680] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.032755] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.032757] HPET id 0 under DRHD base 0xfed91000
[    0.032758] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.032936] Enabled IRQ remapping in x2apic mode
[    0.032937] Enabling x2apic
[    0.032938] Enabled x2apic
[    0.032946] Switched APIC routing to cluster x2apic.
[    0.033430] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073159] smpboot: CPU0: Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz (fam: 06, model: 3a, stepping: 09)
[    0.073171] TSC deadline timer enabled
[    0.073200] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.073225] ... version:                3
[    0.073226] ... bit width:              48
[    0.073227] ... generic registers:      4
[    0.073228] ... value mask:             0000ffffffffffff
[    0.073229] ... max period:             0000ffffffffffff
[    0.073230] ... fixed-purpose events:   3
[    0.073231] ... event mask:             000000070000000f
[    0.074871] x86: Booting SMP configuration:
[    0.074874] .... node  #0, CPUs:      #1
[    0.088665] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.088780]  #2
[    0.100185] CPU2 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.102959]  #3
[    0.116542] x86: Booted up 1 node, 4 CPUs
[    0.116545] smpboot: Total of 4 processors activated (19954.32 BogoMIPS)
[    0.121333] devtmpfs: initialized
[    0.125441] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.126579] pinctrl core: initialized pinctrl subsystem
[    0.126706] NET: Registered protocol family 16
[    0.137132] cpuidle: using governor ladder
[    0.146933] cpuidle: using governor menu
[    0.147007] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.147009] ACPI: bus type PCI registered
[    0.147011] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.147219] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.147222] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.147316] PCI: Using configuration type 1 for base access
[    0.157682] ACPI: Added _OSI(Module Device)
[    0.157684] ACPI: Added _OSI(Processor Device)
[    0.157686] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.157687] ACPI: Added _OSI(Processor Aggregator Device)
[    0.159513] ACPI : EC: EC description table is found, configuring boot EC
[    0.165042] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.225998] ACPI: Dynamic OEM Table Load:
[    0.226017] ACPI: SSDT 0xFFFF88011901D000 000A01 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.241636] ACPI: Dynamic OEM Table Load:
[    0.241652] ACPI: SSDT 0xFFFF8801190A0C00 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.251237] ACPI: Dynamic OEM Table Load:
[    0.251251] ACPI: SSDT 0xFFFF880119060E00 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.262137] ACPI: Interpreter enabled
[    0.262145] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.262150] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.262166] ACPI: (supports S0 S3 S4 S5)
[    0.262168] ACPI: Using IOAPIC for interrupt routing
[    0.262198] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.277877] ACPI: Power Resource [PUBS] (on)
[    0.278597] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.279663] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.282794] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.282899] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
[    0.283002] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.283101] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 9 10 11)
[    0.283181] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.283281] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11)
[    0.283382] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.283483] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.283595] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.283601] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.283740] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.283802] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.283805] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.283807] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.283809] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.284004] PCI host bridge to bus 0000:00
[    0.284007] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.284010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.284012] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.284014] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.284016] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.284018] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.284027] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.284131] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.284144] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.284151] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.284156] pci 0000:00:02.0: reg 0x20: [io  0x4000-0x403f]
[    0.284278] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.284304] pci 0000:00:14.0: reg 0x10: [mem 0xf1500000-0xf150ffff 64bit]
[    0.284385] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.284423] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.284484] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.284512] pci 0000:00:16.0: reg 0x10: [mem 0xf1515000-0xf151500f 64bit]
[    0.284598] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.284689] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.284711] pci 0000:00:16.3: reg 0x10: [io  0x4090-0x4097]
[    0.284722] pci 0000:00:16.3: reg 0x14: [mem 0xf151b000-0xf151bfff]
[    0.284893] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.284918] pci 0000:00:1a.0: reg 0x10: [mem 0xf151a000-0xf151a3ff]
[    0.285019] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.285057] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.285119] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.285138] pci 0000:00:1b.0: reg 0x10: [mem 0xf1510000-0xf1513fff 64bit]
[    0.285224] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.285269] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.285329] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.285479] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.285585] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.285728] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.285776] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.285848] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.285873] pci 0000:00:1d.0: reg 0x10: [mem 0xf1519000-0xf15193ff]
[    0.285975] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.286014] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.286072] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    0.286265] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.286288] pci 0000:00:1f.2: reg 0x10: [io  0x4088-0x408f]
[    0.286298] pci 0000:00:1f.2: reg 0x14: [io  0x409c-0x409f]
[    0.286307] pci 0000:00:1f.2: reg 0x18: [io  0x4080-0x4087]
[    0.286317] pci 0000:00:1f.2: reg 0x1c: [io  0x4098-0x409b]
[    0.286326] pci 0000:00:1f.2: reg 0x20: [io  0x4060-0x407f]
[    0.286335] pci 0000:00:1f.2: reg 0x24: [mem 0xf1518000-0xf15187ff]
[    0.286388] pci 0000:00:1f.2: PME# supported from D3hot
[    0.286473] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.286492] pci 0000:00:1f.3: reg 0x10: [mem 0xf1514000-0xf15140ff 64bit]
[    0.286515] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.286847] pci 0000:02:00.0: [1180:e822] type 00 class 0x088001
[    0.286872] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.286900] pci 0000:02:00.0: reg 0x10: [mem 0xf0d00000-0xf0d000ff]
[    0.287146] pci 0000:02:00.0: supports D1 D2
[    0.287148] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297760] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.297765] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.297771] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.297780] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.298038] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.298240] pci 0000:03:00.0: reg 0x10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.299050] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.309605] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.309615] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.310967] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.311043] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.311173] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.311175] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.311179] vgaarb: loaded
[    0.311180] vgaarb: bridge control possible 0000:00:02.0
[    0.311256] PCI: Using ACPI for IRQ routing
[    0.312991] PCI: pci_cache_line_size set to 64 bytes
[    0.313346] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.313348] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.313350] e820: reserve RAM buffer [mem 0xced49000-0xcfffffff]
[    0.313352] e820: reserve RAM buffer [mem 0x11e600000-0x11fffffff]
[    0.313530] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.313537] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.316577] Switched to clocksource hpet
[    0.324114] pnp: PnP ACPI init
[    0.324638] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.324641] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.324643] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.324645] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.324647] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.324650] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.324652] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.324654] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.324656] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.324658] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.324661] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.324663] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.324665] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.324667] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.324670] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.324672] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.324674] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.324678] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.324782] pnp 00:01: [Firmware Bug]: PNP resource [mem 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending to [mem 0xfed10000-0xfed17fff]
[    0.324808] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.324810] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.324812] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.324815] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.324817] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.324820] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.324822] system 00:01: [mem 0xfffff000-0xffffffff] has been reserved
[    0.324825] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.324827] system 00:01: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.324829] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.324831] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.324834] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.324836] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.324911] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.324952] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.324989] pnp 00:04: Plug and Play ACPI device, IDs LEN0030 PNP0f13 (active)
[    0.325046] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.325462] pnp: PnP ACPI: found 6 devices
[    0.333034] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.333043] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.333050] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.333056] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.333065] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.333072] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.333085] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.333087] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.333089] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.333091] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.333093] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.333095] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.333097] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.333099] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.333101] pci_bus 0000:03: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.333176] NET: Registered protocol family 2
[    0.333409] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.333538] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.333806] TCP: Hash tables configured (established 32768 bind 32768)
[    0.333824] TCP: reno registered
[    0.333841] UDP hash table entries: 2048 (order: 5, 196608 bytes)
[    0.333904] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
[    0.334037] NET: Registered protocol family 1
[    0.334054] pci 0000:00:02.0: Video device with shadowed ROM
[    0.334595] PCI: CLS 64 bytes, default 64
[    0.334646] Unpacking initramfs...
[    0.805861] Freeing initrd memory: 22800K (ffff880035368000 - ffff8800369ac000)
[    0.805901] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.805904] software IO TLB [mem 0xcad49000-0xced49000] (64MB) mapped at [ffff8800cad49000-ffff8800ced48fff]
[    0.806191] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.806328] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x1b
[    0.806337] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x1b
[    0.806344] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x1b
[    0.806355] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x1b
[    0.806433] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.806831] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.806900] audit: initializing netlink subsys (disabled)
[    0.806922] audit: type=2000 audit(1418715362.796:1): initialized
[    0.807405] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.807431] zpool: loaded
[    0.807433] zbud: loaded
[    0.807628] VFS: Disk quotas dquot_6.5.2
[    0.807654] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.807727] msgmni has been set to 7323
[    0.808229] alg: No test for stdrng (krng)
[    0.808277] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.808333] io scheduler noop registered
[    0.808338] io scheduler deadline registered
[    0.808362] io scheduler cfq registered (default)
[    0.808768] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.808790] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.808850] intel_idle: MWAIT substates: 0x21120
[    0.808852] intel_idle: v0.4 model 0x3A
[    0.808853] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.809168] GHES: HEST is not enabled!
[    0.809267] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.830064] serial 0000:00:16.3: ttyS0 at I/O 0x4090 (irq = 19, base_baud = 115200) is a 16550A
[    0.830264] Linux agpgart interface v0.103
[    0.830407] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.832176] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.832181] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.832325] mousedev: PS/2 mouse device common for all mice
[    0.832387] rtc_cmos 00:02: RTC can wake from S4
[    0.832562] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.832601] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.832614] Intel P-state driver initializing.
[    0.832974] ledtrig-cpu: registered to indicate activity on CPUs
[    0.833855] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.834839] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.834842] AMD IOMMUv2 functionality not available on this system
[    0.835083] TCP: cubic registered
[    0.835231] NET: Registered protocol family 10
[    0.835809] mip6: Mobile IPv6
[    0.835819] NET: Registered protocol family 17
[    0.835835] mpls_gso: MPLS GSO support
[    0.836926] registered taskstats version 1
[    0.838496] rtc_cmos 00:02: setting system clock to 2014-12-16 07:36:03 UTC (1418715363)
[    0.840844] Freeing unused kernel memory: 1212K (ffffffff81906000 - ffffffff81a35000)
[    0.840848] Write protecting the kernel read-only data: 8192k
[    0.845236] Freeing unused kernel memory: 812K (ffff880001535000 - ffff880001600000)
[    0.846491] Freeing unused kernel memory: 232K (ffff8800017c6000 - ffff880001800000)
[    0.867779] systemd-udevd[73]: starting version 215
[    0.868797] random: systemd-udevd urandom read with 4 bits of entropy available
[    0.904293] thermal LNXTHERM:00: registered as thermal_zone0
[    0.904300] ACPI: Thermal Zone [THM0] (46 C)
[    0.905530] sdhci: Secure Digital Host Controller Interface driver
[    0.905534] sdhci: Copyright(c) Pierre Ossman
[    0.906613] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e822] (rev 7)
[    0.907295] sdhci-pci 0000:02:00.0: No vmmc regulator found
[    0.907300] sdhci-pci 0000:02:00.0: No vqmmc regulator found
[    0.908647] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    0.910019] SCSI subsystem initialized
[    0.912940] libata version 3.00 loaded.
[    0.915694] ahci 0000:00:1f.2: version 3.0
[    0.915910] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    0.915993] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    0.916000] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.923046] scsi host0: ahci
[    0.923809] scsi host1: ahci
[    0.924017] scsi host2: ahci
[    0.924501] scsi host3: ahci
[    0.924732] scsi host4: ahci
[    0.925004] scsi host5: ahci
[    0.925161] ata1: SATA max UDMA/133 abar m2048@0xf1518000 port 0xf1518100 irq 26
[    0.925165] ata2: DUMMY
[    0.925167] ata3: DUMMY
[    0.925169] ata4: DUMMY
[    0.925171] ata5: DUMMY
[    0.925182] ata6: DUMMY
[    1.241787] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.242521] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.242531] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.246401] ata1.00: ATA-8: SanDisk SD5SG2256G1052E, 10.02.01, max UDMA/133
[    1.246407] ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.247240] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.247248] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.248312] ata1.00: configured for UDMA/133
[    1.248641] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SD5SG225 2.01 PQ: 0 ANSI: 5
[    1.254360] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.254681] sd 0:0:0:0: [sda] Write Protect is off
[    1.254690] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.254761] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.256146]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.257650] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.259155] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.315152] PM: Starting manual resume from disk
[    1.353674] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    1.565056] systemd[1]: RTC configured in localtime, applying delta of -480 minutes to system time.
[    1.782871] systemd[1]: Cannot add dependency job for unit slcand.service, ignoring: Unit slcand.service failed to load: No such file or directory.
[    1.806294] tsc: Refined TSC clocksource calibration: 2494.342 MHz
[    1.822382] fuse init (API version 7.23)
[    1.826717] loop: module loaded
[    1.863662] systemd-udevd[199]: starting version 215
[    1.961019] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[    2.094531] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    2.094652] ACPI: Lid Switch [LID]
[    2.094713] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    2.094718] ACPI: Sleep Button [SLPB]
[    2.094803] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    2.094807] ACPI: Power Button [PWRF]
[    2.100462] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\_SB_.PCI0.LPC_.PMIO) (20140926/utaddress-258)
[    2.100467] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.100471] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.100473] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.100474] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.100476] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.100477] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.100480] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.100480] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    2.119433] mei_me 0000:00:16.0: irq 27 for MSI/MSI-X
[    2.124039] ACPI: AC Adapter [AC] (on-line)
[    2.124667] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.133227] ACPI: Battery Slot [BAT0] (battery present)
[    2.137138] wmi: Mapper loaded
[    2.137373] Non-volatile memory driver v1.3
[    2.143385] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    2.144654] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    2.147991] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    2.156441] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    2.156444] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.156445] thinkpad_acpi: ThinkPad BIOS G6ET59WW (2.03 ), EC unknown
[    2.156446] thinkpad_acpi: Lenovo ThinkPad X1 Carbon, model 3443CTO
[    2.156985] thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
[    2.157184] thinkpad_acpi: radio switch found; radios are enabled
[    2.157304] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    2.157306] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    2.158847] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    2.159357] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    2.160702] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    2.161208] ACPI: bus type USB registered
[    2.161313] usbcore: registered new interface driver usbfs
[    2.161368] usbcore: registered new interface driver hub
[    2.161403] usbcore: registered new device driver usb
[    2.180816] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.180824] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.180912] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.180934] xhci_hcd 0000:00:14.0: irq 28 for MSI/MSI-X
[    2.180998] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.181000] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.181001] usb usb1: Product: xHCI Host Controller
[    2.181002] usb usb1: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.181003] usb usb1: SerialNumber: 0000:00:14.0
[    2.181122] hub 1-0:1.0: USB hub found
[    2.181130] hub 1-0:1.0: 4 ports detected
[    2.181543] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.181548] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.181589] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.181591] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.181593] usb usb2: Product: xHCI Host Controller
[    2.181594] usb usb2: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.181596] usb usb2: SerialNumber: 0000:00:14.0
[    2.181715] hub 2-0:1.0: USB hub found
[    2.181727] hub 2-0:1.0: 4 ports detected
[    2.181890] usb: failed to peer usb2-port2 and usb1-port1 by location (usb2-port2:none) (usb1-port1:usb2-port1)
[    2.181891] usb usb2-port2: failed to peer to usb1-port1 (-16)
[    2.181892] usb: port power management may be unreliable
[    2.182078] usb: failed to peer usb2-port3 and usb1-port1 by location (usb2-port3:none) (usb1-port1:usb2-port1)
[    2.182080] usb usb2-port3: failed to peer to usb1-port1 (-16)
[    2.182192] usb: failed to peer usb2-port4 and usb1-port1 by location (usb2-port4:none) (usb1-port1:usb2-port1)
[    2.182194] usb usb2-port4: failed to peer to usb1-port1 (-16)
[    2.186705] iTCO_vendor_support: vendor-support=0
[    2.189143] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.189180] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    2.189246] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.206778] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    2.209376] AVX version of gcm_enc/dec engaged.
[    2.209379] AES CTR mode by8 optimization enabled
[    2.211589] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.230955] alg: No test for crc32 (crc32-pclmul)
[    2.240498] [drm] Initialized drm 1.1.0 20060810
[    2.242923] cfg80211: Calling CRDA to update world regulatory domain
[    2.247481] snd_hda_intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    2.256459] sound hdaudioC0D0: No codec parser is available
[    2.256737] sound hdaudioC0D3: No codec parser is available
[    2.281006] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    2.281008] Copyright(c) 2003- 2014 Intel Corporation
[    2.281165] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.281318] iwlwifi 0000:03:00.0: irq 30 for MSI/MSI-X
[    2.281438] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-6.ucode failed with error -2
[    2.281451] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-5.ucode failed with error -2
[    2.281453] iwlwifi 0000:03:00.0: request for firmware file 'iwlwifi-6000g2a-5.ucode' failed.
[    2.281521] iwlwifi 0000:03:00.0: no suitable firmware found!
[    2.303852] Adding 3785724k swap on /dev/sda7.  Priority:-1 extents:1 across:3785724k SSFS
[    2.305401] cfg80211: World regulatory domain updated:
[    2.305403] cfg80211:  DFS Master region: unset
[    2.305404] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.305406] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.305407] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.305409] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.305410] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    2.305411] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.305412] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.305413] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.305414] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.392117] EXT4-fs (sda5): mounting ext2 file system using the ext4 subsystem
[    2.393920] EXT4-fs (sda5): mounted filesystem without journal. Opts: (null)
[    2.399659] [drm] Memory usable by graphics device = 2048M
[    2.399662] [drm] Replacing VGA console driver
[    2.400606] Console: switching to colour dummy device 80x25
[    2.401978] systemd-journald[178]: Received request to flush runtime journal from PID 1
[    2.423043] i915 0000:00:02.0: irq 30 for MSI/MSI-X
[    2.423058] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.423059] [drm] Driver supports precise vblank timestamp query.
[    2.423130] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.475378] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.475457] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
[    2.475661] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    2.531157] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    2.603280] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    2.607130] RPC: Registered named UNIX socket transport module.
[    2.607132] RPC: Registered udp transport module.
[    2.607133] RPC: Registered tcp transport module.
[    2.607134] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.615914] FS-Cache: Loaded
[    2.620026] fbcon: inteldrmfb (fb0) is primary device
[    2.653203] FS-Cache: Netfs 'nfs' registered for caching
[    2.683476] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.807796] Switched to clocksource tsc
[    2.903109] [drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    2.903111] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[    2.992321] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2182, fw id: 1164733
[    2.992340] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    3.031308] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[    3.364902] Console: switching to colour frame buffer device 200x56
[    3.373650] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.373652] i915 0000:00:02.0: registered panic notifier
[    3.676431] random: nonblocking pool is initialized
[    7.092288] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    7.286827] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9

-- 
- Jeremiah Mahler
