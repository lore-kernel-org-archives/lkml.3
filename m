Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaFKMtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaFKMs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:48:59 -0400
Date: Wed, 11 Jun 2014 14:48:46 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140611144846.4a55410a@nial.usersys.redhat.com>
In-Reply-To: <20140611061624.GA12132@sucs.org>
References: <20140608090223.GA8703@sucs.org>
	<20140609122616.124ebe43@thinkpad>
	<20140611061624.GA12132@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 07:16:24 +0100
Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> On Mon, Jun 09, 2014 at 12:26:16PM +0200, Igor Mammedov wrote:
> > On Sun, 8 Jun 2014 10:02:23 +0100
> > Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > 
> > > The latest kernel (c593e8978722f7f4a12932733cfeed6c0c74fbaa) refuses to
> > > boot on my EeePC - after grub is finished the screen just remains black
> > > and the only thing that does something is pressing the power button. The
> > > problem commit seems to be:
> > I'm sorry for introducing mess, I don't have EeePC to test this on.
> > Could you help to track problem on it?
> > Is there any output if you boot affected kernel with
> > "earlyprintk=vga ignore_loglevel" options?
> 
> It basically gives up just before Initializing CPU#0. The following is
> an approximation of the boot messages that I see on the screen (the
> early ones are gone before I can eyeball them so this is a blend of a
> previous dmesg and what I see on the screen during a failure):
Thanks for answer,

I've overlooked nonsmp case when testing where no one sets
cpu_callout_mask for boot CPU and as result kernel hangs in cpu_init()

#0  wait_for_master_cpu () at arch/x86/kernel/cpu/common.c:1232
#1  cpu_init () at arch/x86/kernel/cpu/common.c:1254
#2  0xffffffff81b0a038 in trap_init () at arch/x86/kernel/traps.c:786
#3  0xffffffff81b06ee3 in start_kernel () at init/main.c:536
#4  0xffffffff81b065df in x86_64_start_reservations (real_mode_data=<value optimized out>) at arch/x86/kernel/head64.c:193
#5  0xffffffff81b06785 in x86_64_start_kernel (real_mode_data=0x13dc0 <Address 0x13dc0 out of bounds>) at arch/x86/kernel/head64.c:182

I also need double-check xen setup since it also uses cpu_init().

I'll resubmit fixed patch after testing is done.

> 
> [    0.000000] Linux version 3.15.0-0001-gd37cf73 (swheeler@eject) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #52 Sun Jun 8 22:43:01 BST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003f77ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003f780000-0x000000003f78ffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000003f790000-0x000000003f7cffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000003f7d0000-0x000000003f7ddfff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000003f7e0000-0x000000003f7fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyvga0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.5 present.
> [    0.000000] DMI: ASUSTeK Computer INC. 900/900, BIOS 1006    03/03/2009
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x3f780 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-DFFFF uncachable
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask FC0000000 write-back
> [    0.000000]   1 base 03F800000 mask FFF800000 uncachable
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] initial memory mapped: [mem 0x00000000-0x00bfffff]
> [    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x3f000000-0x3f3fffff]
> [    0.000000]  [mem 0x3f000000-0x3f3fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x38000000-0x3effffff]
> [    0.000000]  [mem 0x38000000-0x3effffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x37ffffff]
> [    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x37ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x3f400000-0x3f77ffff]
> [    0.000000]  [mem 0x3f400000-0x3f77ffff] page 4k
> [    0.000000] BRK [0x00667000, 0x00667fff] PGTABLE
> [    0.000000] ACPI: RSDP 0x000FBE90 000014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT 0x3F780000 000034 (v01 A M I  OEMRSDT  03000903 MSFT 00000097)
> [    0.000000] ACPI: FACP 0x3F780200 000081 (v01 A M I  OEMFACP  03000903 MSFT 00000097)
> [    0.000000] ACPI: DSDT 0x3F780400 0060FD (v01 A0979  A0979036 00000036 INTL 20060113)
> [    0.000000] ACPI: FACS 0x3F790000 000040
> [    0.000000] ACPI: APIC 0x3F780390 000068 (v01 A M I  OEMAPIC  03000903 MSFT 00000097)
> [    0.000000] ACPI: OEMB 0x3F790040 000046 (v01 A M I  AMI_OEM  03000903 MSFT 00000097)
> [    0.000000] ACPI: MCFG 0x3F786500 00003C (v01 A M I  OEMMCFG  03000903 MSFT 00000097)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 1015MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 3f780000
> [    0.000000]   low ram: 0 - 3f780000
> [    0.000000] Zone ranges:
> [    0.000000]   Normal   [mem 0x00001000-0x3f77ffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x3f77ffff]
> [    0.000000] On node 0 totalpages: 259870
> [    0.000000] free_area_init_node: node 0, pgdat b05e48c4, node_mem_map eef90020
> [    0.000000]   Normal zone: 2031 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 259870 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] Reserving Intel graphics stolen memory at 0x3f800000-0x3fffffff
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x40000000-0xfedfffff] available for PCI devices
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257839
> [    0.000000] Kernel command line: BOOT_IMAGE=/home/eeeuser/bzImage root=/dev/sdb2 ro rootfstype=ext4 usb_storage.delay_use=0 boot_delay=50 earlyprintk=vga ignore_loglevel
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> 

