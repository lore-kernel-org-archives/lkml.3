Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3AKMeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:34:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab3AKMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:34:02 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Fri, 11 Jan 2013 13:33:48 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-24-desktop; KDE/4.6.0; x86_64; ; )
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org,
        horms@verge.net.au
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1586060.uJlkOEQfVW@hammer82.arch.suse.de> <CAE9FiQVLVxj07TM1N6F2kmZdBYMUiS6Xz2bD-JZPtvps3a5-xw@mail.gmail.com>
In-Reply-To: <CAE9FiQVLVxj07TM1N6F2kmZdBYMUiS6Xz2bD-JZPtvps3a5-xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_taA8QmT0E35OkgI"
Message-Id: <201301111333.49238.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_taA8QmT0E35OkgI
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit

On Friday, January 11, 2013 12:34:37 AM Yinghai Lu wrote:
> On Wed, Jan 9, 2013 at 7:21 PM, Thomas Renninger <trenn@suse.de> wrote:
...
> > Can kexec simply pass the memory to use via memmap=X@Y
> > Then take the original e820 table, but not the usable entries (those
> > are coming from above memmap=X@Y).
> > That would mean that the kexec kernel takes all the
> > original ACPI, ACPI NVS, reserved, unusable (everthing but usable)
> > entries from the original e820 table and identifies the usable memory
> > from memmap boot param?
> 
> kdump scripts already do that for acpi regions, need to update it
> to append that for mmconf.

No, this must get fixed properly:
Use "unusable (ACPI, reserved, whatever..)" regions from the e820 table
passed through bootloader structure.

Only replace "usable" memory areas with the ones passed via memmap=
if memmap=exactmap is passed.

Only taking mmconf area is wrong, kdump kernel has to honour *all*
original reserved memory areas and the info is already there.
I also do not see any kernel vs kexec version incompatibilities with
my approach. Future kexec version can clean up and do not need to
pass ACPI memory area/range via memmap=X#Y anymore.

You find a suitable patch at the end.
I just zeroed out the e820 usable entries (same as e820_remove_range()
above), sanitize_e820_map() should fix that up and it's ensured that
it is called in memmap=exactmap case.

Find serial output of a try (same machine as with my previous posts).
There you find the correctly modified e820 user defined table (all
unusable entries, but usable entries are adjusted) until mmconf
is used gracefully.

> > This would be much smarter than trying to pass the mmconf reserved
> > area and I could imagine other issues will show up if the reserved
> > areas do not match the original ones in the kexec kernel.
> >
> > If this really can be done and memmap=exactmap was only used by kexec,
> > it's logic could be redefined from "drop all e820 entries" to
> > "drop all usable e820 entries" and no further adjustings in
> > kexec/kernel are needed to get mmconf working (and other issues may be
> > avoided before they happen). Beside that ACPI reserved aread is not
> > needed anymore to get passed via memmap=X#Y by kexec.

> yes, we have other user for debug  like simulating user memmap for some
> bugs.
> current problem for exactmap is that we don't scan that at first.
> attached patch could help that.

Yep, this is what I would have come up as well or similar. I looked
at it, but I had no time for doing it and trying out.

You may want to add:
Reviewed-by: Thomas Renninger <trenn@suse.de>
if someone reposts.

   Thomas

-------------------
x86 e820: only void usable memory areas in memmap=exactmap case

All unusable (reserved, ACPI, ACPI NVS,...) areas have to be
honored in kdump case.
Othwerise ACPI parts will quickly run into trouble when trying
to for example early_ioremap reserved areas which are not
declared reserved in kdump kernel.
mmconf area must also be a reserved mem region.
...

Passing unusable memory via memmap= is a design flaw as
this information is already (exactly for this purpose) passed
via bootloader structure.
In kdump case (when memmap=exactmap is passed), only void
(do not use) usable memory regions from the passed e820 table
and use memory areas defined via memmap=X@Y boot parameter instead.
But do still use the "unusable" memory regions from the original e820
table.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/e820.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dc0b9f0..ae2d657 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -559,6 +559,19 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 	return real_removed_size;
 }
 
+static void __init e820_remove_range_type(u32 type)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		if (ei->type == type) {
+			memset(ei, 0, sizeof(struct e820entry));
+			continue;
+		}
+	}
+}
+
 void __init update_e820(void)
 {
 	u32 nr_map;
@@ -858,7 +871,11 @@ static int __init parse_memmap_one(char *p)
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
-		e820.nr_map = 0;
+		/*
+		 * Remove all usable memory (this is for kdump), usable
+		 * memory will be passed via memmap=X@Y parameter
+		 */
+		e820_remove_range_type(E820_RAM);
 		userdef = 1;
 		return 0;
 	}

--Boundary-00=_taA8QmT0E35OkgI
Content-Type: text/plain;
  charset="UTF-8";
  name="screen.xy"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="screen.xy"

RIP  [<ffffffff813b05b1>] sysrq_handle_crash+0x11/0x20
 RSP <ffff882f5ca71e38>
CR2: 0000000000000000
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.8.0-rc2-default+ (trenn@ett) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #6 SMP Fri Jan 11 10:52:17 CET 2013
Command line: root=/dev/disk/by-label/ROOT-BE2 resume=/dev/disk/by-id/scsi-36d4ae52076eef40017f5c9690b9c848e-part8 nmi_watchdog=0 elevator=noop log_buf_len=4M printk.time=0 udev_timeout=180 cgroup_disable=memory console=tty0 console=ttyS0,115200n elevator=deadline sysrq=yes reset_devices irqpoll maxcpus=1  sysrq=7 debug ignore_loglevel memmap=exactmap memmap=560K@64K memmap=392628K@114688K elfcorehdr=507316K memmap=252K#3099760K
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000100-0x000000000009bfff] usable
BIOS-e820: [mem 0x0000000000100000-0x00000000bd2effff] usable
BIOS-e820: [mem 0x00000000bd2f0000-0x00000000bd31bfff] reserved
BIOS-e820: [mem 0x00000000bd31c000-0x00000000bd35afff] ACPI data
BIOS-e820: [mem 0x00000000bd35b000-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
BIOS-e820: [mem 0x00000000fe000000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000603fffffff] usable
debug: ignoring loglevel setting.
e820: last_pfn = 0x6040000 max_arch_pfn = 0x400000000
NX (Execute Disable) protection: active
e820: user-defined physical RAM map:
user: [mem 0x0000000000010000-0x000000000009bfff] usable
user: [mem 0x0000000007000000-0x000000001ef6cfff] usable
user: [mem 0x00000000bd2f0000-0x00000000bd31bfff] reserved
user: [mem 0x00000000bd31c000-0x00000000bd35afff] ACPI data
user: [mem 0x00000000bd35b000-0x00000000bfffffff] reserved
user: [mem 0x00000000e0000000-0x00000000efffffff] reserved
user: [mem 0x00000000fe000000-0x00000000ffffffff] reserved
SMBIOS 2.7 present.
DMI: Dell Inc. PowerEdge R720/0M1GCR, BIOS 0.3.35 12/15/2011
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x1ef6d max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CBFFF write-protect
  CC000-D7FFF write-back
  D8000-EBFFF uncachable
  EC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask 3FC000000000 write-back
  1 base 004000000000 mask 3FE000000000 write-back
  2 base 006000000000 mask 3FFFC0000000 write-back
  3 base 0000C0000000 mask 3FFFC0000000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000096000] 96000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x1ef6cfff]
 [mem 0x00000000-0x1edfffff] page 2M
 [mem 0x1ee00000-0x1ef6cfff] page 4k
kernel direct mapping tables up to 0x1ef6cfff @ [mem 0x1ef6a000-0x1ef6cfff]
log_buf_len: 4194304
early log buf free: 258076(98%)
RAMDISK: [mem 0x1e9ac000-0x1ef5bfff]
ACPI: RSDP 00000000000f10d0 00024 (v02 DELL  )
ACPI: XSDT 00000000000f11d4 0009C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: FACP 00000000bd34111c 000F4 (v03 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DSDT 00000000bd31c000 05FCD (v01 DELL   PE_SC3   00000001 INTL 20110211)
ACPI: FACS 00000000bd343000 00040
ACPI: APIC 00000000bd340478 0016A (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SPCR 00000000bd3405e4 00050 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HPET 00000000bd340638 00038 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DMAR 00000000bd340674 00158 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: MCFG 00000000bd340950 0003C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: WD__ 00000000bd340990 00134 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SLIC 00000000bd340ac8 00176 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: ERST 00000000bd322170 00270 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HEST 00000000bd3223e0 0055C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: BERT 00000000bd321fd0 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: EINJ 00000000bd322000 00170 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SRAT 00000000bd340cf0 003C0 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: TCPA 00000000bd3410b4 00064 (v02 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SSDT 00000000bd344000 0AA14 (v01 INTEL  PPM RCM  80000001 INTL 20061109)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 1 -> APIC 0x00 -> Node 0
SRAT: PXM 2 -> APIC 0x20 -> Node 1
SRAT: PXM 1 -> APIC 0x02 -> Node 0
SRAT: PXM 2 -> APIC 0x22 -> Node 1
SRAT: PXM 1 -> APIC 0x04 -> Node 0
SRAT: PXM 2 -> APIC 0x24 -> Node 1
SRAT: PXM 1 -> APIC 0x06 -> Node 0
SRAT: PXM 2 -> APIC 0x26 -> Node 1
SRAT: PXM 1 -> APIC 0x08 -> Node 0
SRAT: PXM 2 -> APIC 0x28 -> Node 1
SRAT: PXM 1 -> APIC 0x0a -> Node 0
SRAT: PXM 2 -> APIC 0x2a -> Node 1
SRAT: PXM 1 -> APIC 0x0c -> Node 0
SRAT: PXM 2 -> APIC 0x2c -> Node 1
SRAT: PXM 1 -> APIC 0x0e -> Node 0
SRAT: PXM 2 -> APIC 0x2e -> Node 1
SRAT: PXM 1 -> APIC 0x01 -> Node 0
SRAT: PXM 2 -> APIC 0x21 -> Node 1
SRAT: PXM 1 -> APIC 0x03 -> Node 0
SRAT: PXM 2 -> APIC 0x23 -> Node 1
SRAT: PXM 1 -> APIC 0x05 -> Node 0
SRAT: PXM 2 -> APIC 0x25 -> Node 1
SRAT: PXM 1 -> APIC 0x07 -> Node 0
SRAT: PXM 2 -> APIC 0x27 -> Node 1
SRAT: PXM 1 -> APIC 0x09 -> Node 0
SRAT: PXM 2 -> APIC 0x29 -> Node 1
SRAT: PXM 1 -> APIC 0x0b -> Node 0
SRAT: PXM 2 -> APIC 0x2b -> Node 1
SRAT: PXM 1 -> APIC 0x0d -> Node 0
SRAT: PXM 2 -> APIC 0x2d -> Node 1
SRAT: PXM 1 -> APIC 0x0f -> Node 0
SRAT: PXM 2 -> APIC 0x2f -> Node 1
SRAT: Node 0 PXM 1 [mem 0x00000000-0x303fffffff]
SRAT: Node 1 PXM 2 [mem 0x3040000000-0x603fffffff]
Initmem setup node 0 [mem 0x00000000-0x1ef6cfff]
  NODE_DATA [mem 0x1e598000-0x1e5abfff]
 [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001d400000-ffff88001dbfffff] on node 0
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009bfff]
  node   0: [mem 0x07000000-0x1ef6cfff]
On node 0 totalpages: 98297
  DMA zone: 3 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 131 pages, LIFO batch:0
  DMA32 zone: 1534 pages used for memmap
  DMA32 zone: 96623 pages, LIFO batch:31
pci 0000:01:00.0 save state
pci 0000:01:00.1 save state
pci 0000:01:00.2 save state
pci 0000:01:00.3 save state
pci 0000:02:00.0 save state
pci 0000:05:00.0 save state
pci 0000:48:00.0 save state
pci 0000:48:00.1 save state
pci 0000:44:00.0 save state
pci 0000:45:00.0 save state
pci 0000:46:00.0 save state
pci 0000:47:00.0 save state
pci 0000:00:01.0 reset
pci 0000:00:02.2 reset
pci 0000:00:03.2 reset
pci 0000:40:02.0 reset
pci 0000:42:05.0 reset
pci 0000:42:06.0 reset
pci 0000:42:08.0 reset
pci 0000:42:09.0 reset
pci 0000:01:00.0 restore state
pci 0000:01:00.1 restore state
pci 0000:01:00.2 restore state
pci 0000:01:00.3 restore state
pci 0000:02:00.0 restore state
pci 0000:05:00.0 restore state
pci 0000:48:00.0 restore state
pci 0000:48:00.1 restore state
pci 0000:44:00.0 restore state
pci 0000:45:00.0 restore state
pci 0000:46:00.0 restore state
pci 0000:47:00.0 restore state
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x26] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x28] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x2a] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2c] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x2e] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x27] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x29] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x2b] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x2d] enabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x2f] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[32])
IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 32-55
ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[64])
IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 64-87
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
smpboot: Allowing 32 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 104
PM: Registered nosave memory: 000000000009c000 - 0000000007000000
e820: [mem 0x1ef6d000-0xbd2effff] available for PCI devices
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:32 nr_node_ids:2
PERCPU: Embedded 27 pages/cpu @ffff88001e000000 s81728 r8192 d20672 u131072
pcpu-alloc: s81728 r8192 d20672 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 96754
Policy zone: DMA32
Kernel command line: root=/dev/disk/by-label/ROOT-BE2 resume=/dev/disk/by-id/scsi-36d4ae52076eef40017f5c9690b9c848e-part8 nmi_watchdog=0 elevator=noop log_buf_len=4M printk.time=0 udev_timeout=180 cgroup_disable=memory console=tty0 console=ttyS0,115200n elevator=deadline sysrq=yes reset_devices irqpoll maxcpus=1  sysrq=7 debug ignore_loglevel memmap=exactmap memmap=560K@64K memmap=392628K@114688K elfcorehdr=507316K memmap=252K#3099760K
Disabling memory control group subsystem
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
PID hash table entries: 2048 (order: 2, 16384 bytes)
__ex_table already sorted, skipping sort
xsave: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Memory: 357760k/507316k available (5832k kernel code, 114128k absent, 35428k reserved, 5095k data, 1000k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=32.
NR_IRQS:33024 nr_irqs:2024 16
Extended CMOS year: 2000
Spurious LAPIC timer interrupt on cpu 0
do_IRQ: 0.231 No irq handler for vector (irq -1)
do_IRQ: 0.230 No irq handler for vector (irq -1)
do_IRQ: 0.229 No irq handler for vector (irq -1)
do_IRQ: 0.223 No irq handler for vector (irq -1)
do_IRQ: 0.199 No irq handler for vector (irq -1)
do_IRQ: 0.183 No irq handler for vector (irq -1)
do_IRQ: 0.182 No irq handler for vector (irq -1)
do_IRQ: 0.181 No irq handler for vector (irq -1)
do_IRQ: 0.176 No irq handler for vector (irq -1)
do_IRQ: 0.160 No irq handler for vector (irq -1)
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2699.986 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 5399.97 BogoMIPS (lpj=10799944)
pid_max: default: 32768 minimum: 301
Security Framework initialized
AppArmor: AppArmor initialized
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Initializing cgroup subsys hugetlb
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 20 MCE banks
CPU0: Thermal LVT vector (0xfa) already installed
process: using mwait in idle threads
Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
ACPI: Core revision 20121018
dmar: Host address width 46
dmar: DRHD base: 0x000000d0d00000 flags: 0x0
dmar: IOMMU 0: reg_base_addr d0d00000 ver 1:0 cap d2078c106f0462 ecap f020fe
dmar: DRHD base: 0x000000dc900000 flags: 0x1
dmar: IOMMU 1: reg_base_addr dc900000 ver 1:0 cap d2078c106f0462 ecap f020fe
dmar: RMRR base: 0x000000bf458000 end: 0x000000bf46ffff
dmar: RMRR base: 0x000000bf450000 end: 0x000000bf450fff
dmar: RMRR base: 0x000000bf452000 end: 0x000000bf452fff
dmar: ATSR flags: 0x0
IOAPIC id 2 under DRHD base  0xd0d00000 IOMMU 0
IOAPIC id 0 under DRHD base  0xdc900000 IOMMU 1
IOAPIC id 1 under DRHD base  0xdc900000 IOMMU 1
HPET id 0 under DRHD base 0xdc900000
------------[ cut here ]------------
WARNING: at drivers/iommu/intel_irq_remapping.c:542 intel_enable_irq_remapping+0x7d/0x26f()
Hardware name: PowerEdge R720
Your BIOS is broken and requested that x2apic be disabled
This will leave your machine vulnerable to irq-injection attacks
Use 'intremap=no_x2apic_optout' to override BIOS request
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc2-default+ #6
Call Trace:
 [<ffffffff81047e2a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81047f01>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81afe84f>] intel_enable_irq_remapping+0x7d/0x26f
 [<ffffffff81afeb93>] irq_remapping_enable+0x20/0x22
 [<ffffffff81acf0eb>] enable_IR+0x5d/0x65
 [<ffffffff81acf3d7>] enable_IR_x2apic+0x95/0x247
 [<ffffffff81026099>] ? cpumask_next+0x19/0x20
 [<ffffffff8159b9b8>] ? set_cpu_sibling_map+0x405/0x422
 [<ffffffff81026831>] ? apic_write+0x11/0x20
 [<ffffffff81ad1f26>] default_setup_apic_routing+0x15/0x6e
 [<ffffffff81accfe6>] native_smp_prepare_cpus+0x137/0x234
 [<ffffffff81ac1c8e>] kernel_init_freeable+0xa2/0x1e1
 [<ffffffff815928b0>] ? rest_init+0x80/0x80
 [<ffffffff815928b9>] kernel_init+0x9/0xf0
 [<ffffffff815ae5bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff815928b0>] ? rest_init+0x80/0x80
---[ end trace 3970bb530c07ade7 ]---
Enabled IRQ remapping in xapic mode
x2apic not enabled, IRQ remapping is in xapic mode
Switched APIC routing to physical flat.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Genuine Intel(R) CPU  @ 2.70GHz (fam: 06, model: 2d, stepping: 05)
TSC deadline timer enabled
Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Brought up 1 CPUs
smpboot: Total of 1 processors activated (5399.97 BogoMIPS)
devtmpfs: initialized
RTC time: 12:21:09, date: 01/11/13
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access

--Boundary-00=_taA8QmT0E35OkgI--
