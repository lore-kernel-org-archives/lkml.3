Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3IKQSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:18:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18068 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3IKQSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:18:15 -0400
Date: Wed, 11 Sep 2013 12:17:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911161745.GA5884@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
 <20130911134717.GA10925@phenom.dumpdata.com>
 <20130911135745.GB11043@phenom.dumpdata.com>
 <20130911142545.GA11364@phenom.dumpdata.com>
 <20130911105633.1c029147@gandalf.local.home>
 <20130911152149.GA22076@phenom.dumpdata.com>
 <20130911114708.1b42aec0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911114708.1b42aec0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:47:08AM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 11:21:49 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > 
> > > I'm trying to understand how this will fix it for you. Are you sure you
> > > removed 'xen_nopvspin'?
> > 
> > Yes.
> > > 
> > > If you are calling static_key_slow_inc() before jump_label_init(), then
> > > it should still fail. The static_key_slow_inc() eventually calls
> > > arch_jump_label_transform(), which calls __jump_label_transform() with
> > > init == 0.
> > 
> > Perhaps I am misreading the code, but I believe init is set to one.
> > That is due to us calling:
> > 
> > arch_jump_label_transform (.., JUMP_LABEL_ENABLE)
> > 
> > which calls __jump_label_transform(.., 1)
> > ?
> 
> From what I'm looking at, only arch_jump_label_transform_static() calls
> __jump_label_transform() with a 1 for init. arch_jump_label_transform()
> calls it with 0 for init, which is what eventually gets called by
> xen_init_spinlocks().
> 
> > 
> > Perhaps the 'init' and 'enable' parameters have different meanings?
> 
> Yes they do.
> 
> -- Steve

Adding an stack_dump() gets this:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0upstream-09031-ga22a0fd-dirty (build@build-mk2.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Wed Sep 11 11:42:38 EDT 2013
[    0.000000] Command line: debug selinux=0 earlyprintk=xen console=hvc0 xencons=hvc0 loglevel=10 pci=resource_alignment=00:13.2 xen-pciback.hide=(08:07.0)(08:06.0)(00:12.0)(00:12.1)(00:12.2)(00:13.0)(00:13.1)(00:13.2)(00:14.5) xen-pciback.passthrough=0
[    0.000000] Freeing 9f-100 pfn range: 97 pages freed
[    0.000000] 1-1 mapping on 9f->100
[    0.000000] 1-1 mapping on cfe90->100000
[    0.000000] Released 97 pages of unused memory
[    0.000000] Set 197073 page(s) to 1-1 mapping
[    0.000000] Populating 40000-40061 pfn range: 97 pages added
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] Xen: [mem 0x000000000009f400-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x0000000040060fff] usable
[    0.000000] Xen: [mem 0x0000000040061000-0x00000000cfe8ffff] unusable
[    0.000000] Xen: [mem 0x00000000cfe90000-0x00000000cfe9dfff] ACPI data
[    0.000000] Xen: [mem 0x00000000cfe9e000-0x00000000cfedffff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000cfee0000-0x00000000cfeedfff] reserved
[    0.000000] Xen: [mem 0x00000000cfef0000-0x00000000cfefffff] reserved
[    0.000000] Xen: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] Xen: [mem 0x00000000ff700000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000021fffffff] unusable
[    0.000000] ERROR: earlyprintk= xenboot already used
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  07/18/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x40061 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3fffffff]
[    0.000000]  [mem 0x3fe00000-0x3fffffff] page 4k
[    0.000000] BRK [0x0205a000, 0x0205afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fdfffff]
[    0.000000]  [mem 0x3c000000-0x3fdfffff] page 4k
[    0.000000] BRK [0x0205b000, 0x0205bfff] PGTABLE
[    0.000000] BRK [0x0205c000, 0x0205cfff] PGTABLE
[    0.000000] BRK [0x0205d000, 0x0205dfff] PGTABLE
[    0.000000] BRK [0x0205e000, 0x0205efff] PGTABLE
[    0.000000] BRK [0x0205f000, 0x0205ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
[    0.000000]  [mem 0x00100000-0x3bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x40000000-0x40060fff]
[    0.000000]  [mem 0x40000000-0x40060fff] page 4k
[    0.000000] RAMDISK: [mem 0x02469000-0x06eeefff]
[    0.000000] ACPI: RSDP 00000000000fa930 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cfe90100 00054 (v01 071808 XSDT0330 20080718 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cfe90290 000F4 (v04 071808 FACP0330 20080718 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130725/tbfadt-603)
[    0.000000] ACPI: DSDT 00000000cfe90490 097CC (v02  MTLAX MTLAX2-0 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cfe9e000 00040
[    0.000000] ACPI: APIC 00000000cfe90390 0006C (v02 071808 APIC0330 20080718 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cfe90400 0003C (v01 071808 OEMMCFG  20080718 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cfe9e040 00072 (v01 071808 OEMB0330 20080718 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cfe99c60 00038 (v01 071808 OEMHPET  20080718 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cfe99de0 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000040060fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x40060fff]
[    0.000000]   NODE_DATA [mem 0x4005d000-0x40060fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x40060fff]
[    0.000000] On node 0 totalpages: 262143
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3530 pages used for memmap
[    0.000000]   DMA32 zone: 258145 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] e820: [mem 0xcff00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.2.2-pre (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003fa00000 s85312 r8192 d21184 u524288
[    0.000000] pcpu-alloc: s85312 r8192 d21184 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    4.966096] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258536
[    4.966098] Policy zone: DMA32
[    4.966101] Kernel command line: debug selinux=0 earlyprintk=xen console=hvc0 xencons=hvc0 loglevel=10 pci=resource_alignment=00:13.2 xen-pciback.hide=(08:07.0)(08:06.0)(00:12.0)(00:12.1)(00:12.2)(00:13.0)(00:13.1)(00:13.2)(00:14.5) xen-pciback.passthrough=0
[    4.966892] op trace_clock_global+0x6b/0x120
[    4.966895] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0upstream-09031-ga22a0fd-dirty #1
[    4.966897] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  07/18/2008
[    4.966899]  ffffffff810542e0 ffffffff81c01e28 ffffffff816a0cf3 0000000000000001
[    4.966903]  ffffffff81ca8598 ffffffff81c01e88 ffffffff81051e0a ffffffe8ffffffe8
[    4.966905]  0000001800000000 ffffffff81162980 0000000000000018 ffffff0000441f0f
[    4.966907] Call Trace:
[    4.966912]  [<ffffffff810542e0>] ? poke_int3_handler+0x40/0x40
[    4.966916]  [<ffffffff816a0cf3>] dump_stack+0x59/0x7b
[    4.966920]  [<ffffffff81051e0a>] __jump_label_transform+0x18a/0x230
[    4.966923]  [<ffffffff81162980>] ? fire_user_return_notifiers+0x70/0x70
[    4.966926]  [<ffffffff81051f15>] arch_jump_label_transform_static+0x65/0x90
[    4.966930]  [<ffffffff81cfbbfb>] jump_label_init+0x75/0xa3
[    4.966932]  [<ffffffff81cd3e3c>] start_kernel+0x168/0x3ff
[    4.966934]  [<ffffffff81cd3af2>] ? repair_env_string+0x5b/0x5b
[    4.966938]  [<ffffffff81cd35f3>] x86_64_start_reservations+0x2a/0x2c
[    4.966941]  [<ffffffff81cd833a>] xen_start_kernel+0x594/0x596
[    4.967072] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    5.009945] software IO TLB [mem 0x3a400000-0x3e400000] (64MB) mapped at [ffff88003a400000-ffff88003e3fffff]
[    5.013794] Memory: 868480K/1048572K available (6860K kernel code, 752K rwdata, 2140K rodata, 1708K init, 1876K bss, 180092K reserved)
[    5.014212] Hierarchical RCU implementation.
[    5.014214] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    5.014229] NR_IRQS:33024 nr_irqs:712 16
[    5.014370] xen: sci override: global_irq=9 trigger=0 polarity=1

.... snip.

And here is the patch:

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ee11b7d..e3a41a0 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -44,13 +44,31 @@ static void __jump_label_transform(struct jump_entry *entry,
 	union jump_code_union code;
 	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
+	if (init) {
+		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+		if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
+			bug_at((void *)entry->code, __LINE__);
+	}
 	if (type == JUMP_LABEL_ENABLE) {
 		/*
 		 * We are enabling this jump label. If it is not a nop
 		 * then something must have gone wrong.
 		 */
-		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
-			bug_at((void *)entry->code, __LINE__);
+		if (init) {
+			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0)) {
+				static int log = 0;
+
+				if (log == 0) {
+					pr_warning("op %pS\n", (void *)entry->code);
+					dump_stack();
+				}
+				log++;
+			}
+		}
+		if (!init) {
+			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
+				bug_at((void *)entry->code, __LINE__);
+		}
 
 		code.jump = 0xe9;
 		code.offset = entry->target -
@@ -62,11 +80,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 		 * If this is the first initialization call, then we
 		 * are converting the default nop to the ideal nop.
 		 */
-		if (init) {
-			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
-			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
-				bug_at((void *)entry->code, __LINE__);
-		} else {
+		if (!init) {
 			code.jump = 0xe9;
 			code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
