Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaH0KoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:44:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42747 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaH0KoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:44:12 -0400
Date: Wed, 27 Aug 2014 11:44:08 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140827104408.GC1827@sucs.org>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:30:54AM +0000, Dexuan Cui wrote:
 
> > What is baffles me is the whole UP vs SMP thing - why would UP
> > make this show up consistently? Perhaps some assertions could be added
> > to check that rbi->ring_buffer still has sane values in it after
> > operations on it are finished?
> With more tests, I found vcpus=2 has the same issue, despite  a
> small possibility.
> vcpus=4 seems fine in my limited tests.

<snip>

> Actually I found the direct cause of the panic: sometimes
> vmbus_post_msg() can return 4 (HV_STATUS_INVALID_ALIGNMENT), but
> vmbus_open() doesn't propagate this error to the caller
> synthvid_connect_vsp(), and vmbus_open() " goto error1"  and frees the
> ringbuffer! So later the access to ring_buffer->read_index is caught
> by CONFIG_DEBUG_PAGEALLOC.
> 
> I don't see any "invalid alignment" here... and I can't explain why
> vcpus=4 seems OK... Debugging WIP.
> 
> BTW, please try the attached patch.  With it, the VM doesn't panic in
> my side with vcpus=1 and can boot to shell prompt(looks the boot-up is
> very slow. I have to wait for several minutes...)

A quick tip: inline patches tend to be better than attachments on LKML.
This is because if the mimetype of the attachment is something like
octet/stream then various tools (e.g.
https://lkml.org/lkml/2014/8/26/271 and
https://patchwork.kernel.org/project/LKML/list/?submitter=100981 ) won't
archive/extract the patch...

I rebased your patch on top of the K.Y.'s "Drivers: hv: vmbus: Eliminate
calls to BUG_ON()" patch set (see below). The combination no longer
triggers the bug and it doesn't take too long to boot but the network
interface fails to work (which I believe is .

Rebased vmbus open fixes patch.

---
 drivers/hv/channel.c    | 4 +++-
 drivers/hv/connection.c | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index c7ffd42..964cdc9 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -165,8 +165,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 16c2ccb..17bf48f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -433,6 +433,7 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 		switch (ret) {
 		case HV_STATUS_INSUFFICIENT_BUFFERS:
 		case -ENOMEM:
+			WARN(ret, KERN_ERR "ret = %d\n", ret);
 			break;
 		default:
 			return ret;
@@ -441,6 +442,7 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 		retries++;
 		msleep(100);
 	}
+	WARN(ret, KERN_ERR "ret = %d, retries=%d\n", ret, retries);
 	return ret;
 }
 
-- 
1.9.3

Boot dmesg output (there's no line that mentions retries). The
framebuffer window also didn't resize itself:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc1.x86_64-dirty () (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #129 SMP Wed Aug 27 10:19:17 UTC 2014
[    0.000000] Command line: ro root=UUID=e78f2b16-8836-4e6a-9e5e-fdc6c9d3cfc3 video=hyperv_fb:800x600 LANG=en_US.UTF-8 elevator=noop console=tty0 console=ttyS0,115200n8 initrd=/boot/initramfs-3.17.0-rc1.x86_64-dirty.img BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc1.x86_64-dirty 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000f7feffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f7ff0000-0x00000000f7ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000f7fff000-0x00000000f7ffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000207ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[    0.000000] Hypervisor detected: Microsoft HyperV
[    0.000000] HyperV: features 0xe7f, hints 0x2c
[    0.000000] HyperV: LAPIC Timer Frequency: 0x30d40
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x208000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00000000000 mask 3FF00000000 write-back
[    0.000000]   1 base 00100000000 mask 3F000000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xf7ff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02db0000, 0x02db0fff] PGTABLE
[    0.000000] BRK [0x02db1000, 0x02db1fff] PGTABLE
[    0.000000] BRK [0x02db2000, 0x02db2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207e00000-0x207ffffff]
[    0.000000]  [mem 0x207e00000-0x207ffffff] page 4k
[    0.000000] BRK [0x02db3000, 0x02db3fff] PGTABLE
[    0.000000] BRK [0x02db4000, 0x02db4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x204000000-0x207dfffff]
[    0.000000]  [mem 0x204000000-0x207dfffff] page 4k
[    0.000000] BRK [0x02db5000, 0x02db5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x200000000-0x203ffffff]
[    0.000000]  [mem 0x200000000-0x203ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x180000000-0x1ffffffff]
[    0.000000]  [mem 0x180000000-0x1ffffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0xf7feffff]
[    0.000000]  [mem 0x00100000-0xf7feffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 4k
[    0.000000] RAMDISK: [mem 0x7fa41000-0x7fffefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F56F0 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x00000000F7FF0000 000040 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000F7FF0200 000081 (v02 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x00000000F7FF1724 002E78 (v01 MSFTVM MSFTVM02 00000002 INTL 02002026)
[    0.000000] ACPI: FACS 0x00000000F7FFF000 000040
[    0.000000] ACPI: WAET 0x00000000F7FF1480 000028 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: SLIC 0x00000000F7FF14C0 000176 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: OEM0 0x00000000F7FF16C0 000064 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000F7FF0600 000090 (v02 VRTUAL MICROSFT 00000001 MSFT 00000001)
[    0.000000] ACPI: APIC 0x00000000F7FF0300 00024C (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000F7FFF040 000064 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xf7ffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x207ffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xf7ffffff] + [mem 0x100000000-0x207ffffff] -> [mem 0x00000000-0x207ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x207ffffff]
[    0.000000]   NODE_DATA [mem 0x206fe7000-0x206ffbfff]
[    0.000000]  [ffffea0000000000-ffffea00081fffff] PMD -> [ffff8801fe600000-ffff8802065fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xf7feffff]
[    0.000000]   node   0: [mem 0x100000000-0x207ffffff]
[    0.000000] On node 0 totalpages: 2097038
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 1011696 pages, LIFO batch:31
[    0.000000]   Normal zone: 16896 pages used for memmap
[    0.000000]   Normal zone: 1081344 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x19] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x1d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x1e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x1f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x28] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x29] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x2d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x2e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x2f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x30] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x31] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x32] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x33] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x34] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x35] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x36] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x37] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x38] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x39] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x3a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x3b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x3c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x3d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x3e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x3f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: 64 Processors exceeds NR_CPUS limit of 16
[    0.000000] smpboot: Allowing 16 CPUs, 15 hotplug CPUs
[    0.000000] e820: [mem 0xf8000000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880206c00000 s83840 r0 d22656 u131072
[    0.000000] pcpu-alloc: s83840 r0 d22656 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063737
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=UUID=e78f2b16-8836-4e6a-9e5e-fdc6c9d3cfc3 video=hyperv_fb:800x600 LANG=en_US.UTF-8 elevator=noop console=tty0 console=ttyS0,115200n8 initrd=/boot/initramfs-3.17.0-rc1.x86_64-dirty.img BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc1.x86_64-dirty 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 8135668K/8388152K available (6808K kernel code, 1178K rwdata, 2544K rodata, 1372K init, 15528K bss, 252484K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:552 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: selftest passed
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using PMTIMER reference calibration
[    0.000000] tsc: Detected 3199.983 MHz processor
[    0.008045] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.96 BogoMIPS (lpj=3199983)
[    0.010025] pid_max: default: 32768 minimum: 301
[    0.011159] ACPI: Core revision 20140724
[    0.103761] ACPI: All ACPI Tables successfully acquired
[    0.106455] Security Framework initialized
[    0.107035] SELinux:  Initializing.
[    0.108144] SELinux:  Starting in permissive mode
[    0.115337] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.121696] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.123718] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.124141] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.128863] Initializing cgroup subsys memory
[    0.129098] Initializing cgroup subsys devices
[    0.130087] Initializing cgroup subsys freezer
[    0.132041] Initializing cgroup subsys net_cls
[    0.133070] Initializing cgroup subsys blkio
[    0.134060] Initializing cgroup subsys perf_event
[    0.136065] Initializing cgroup subsys hugetlb
[    0.137364] mce: CPU supports 1 MCE banks
[    0.138085] numa_add_cpu cpu 0 node 0: mask now 0
[    0.138097] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.169318] ftrace: allocating 24816 entries in 97 pages
[    0.186335] Switched APIC routing to physical flat.
[    0.215529] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.216007] smpboot: CPU0: Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz (fam: 06, model: 2d, stepping: 07)
[    0.220384] Performance Events: unsupported p6 CPU model 45 no PMU driver, software events only.
[    0.231651] x86: Booted up 1 node, 1 CPUs
[    0.232017] smpboot: Total of 1 processors activated (6399.96 BogoMIPS)
[    0.234043] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.242364] devtmpfs: initialized
[    0.293674] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.294037] pinctrl core: initialized pinctrl subsystem
[    0.296839] NET: Registered protocol family 16
[    0.300512] cpuidle: using governor menu
[    0.302386] ACPI: bus type PCI registered
[    0.303008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.306170] PCI: Using configuration type 1 for base access
[    0.342917] ACPI: Added _OSI(Module Device)
[    0.343013] ACPI: Added _OSI(Processor Device)
[    0.344010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.345017] ACPI: Added _OSI(Processor Aggregator Device)
[    0.417678] ACPI: Interpreter enabled
[    0.418071] ACPI: (supports S0 S5)
[    0.419016] ACPI: Using IOAPIC for interrupt routing
[    0.420581] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.648052] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.649039] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.650159] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.698504] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.701427] PCI host bridge to bus 0000:00
[    0.702020] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.703021] pci_bus 0000:00: root bus resource [mem 0xfe0000000-0xfffefffff]
[    0.705006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.706016] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.707015] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.708046] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfffbffff]
[    0.710007] pci 0000:00:00.0: [8086:7192] type 00 class 0x060000
[    0.713661] pci 0000:00:07.0: [8086:7110] type 00 class 0x060100
[    0.718391] pci 0000:00:07.1: [8086:7111] type 00 class 0x010180
[    0.721008] pci 0000:00:07.1: reg 0x20: [io  0xffa0-0xffaf]
[    0.722277] pci 0000:00:07.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.723016] pci 0000:00:07.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.724009] pci 0000:00:07.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.725007] pci 0000:00:07.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.728479] pci 0000:00:07.3: [8086:7113] type 00 class 0x068000
[    0.728540] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
[    0.733011] pci 0000:00:07.3: quirk: [io  0x0400-0x043f] claimed by PIIX4 ACPI
[    0.737131] pci 0000:00:08.0: [1414:5353] type 00 class 0x030000
[    0.737680] pci 0000:00:08.0: reg 0x10: [mem 0xf8000000-0xfbffffff]
[    0.847356] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.863953] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.881614] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.898959] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.915427] ACPI: Enabled 1 GPEs in block 00 to 0F
[    0.918449] vgaarb: device added: PCI:0000:00:08.0,decodes=io+mem,owns=io+mem,locks=none
[    0.919017] vgaarb: loaded
[    0.920006] vgaarb: bridge control possible 0000:00:08.0
[    0.923115] SCSI subsystem initialized
[    0.925563] libata version 3.00 loaded.
[    0.929388] hv_vmbus: Hyper-V Host Build:9600-6.3-17-0.17039; Vmbus version:3.0
[    5.931183] PCI: Using ACPI for IRQ routing
[    5.932009] PCI: pci_cache_line_size set to 64 bytes
[    5.933325] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    5.933378] e820: reserve RAM buffer [mem 0xf7ff0000-0xf7ffffff]
[    5.936421] NetLabel: Initializing
[    5.937007] NetLabel:  domain hash size = 128
[    5.938017] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.939225] NetLabel:  unlabeled traffic allowed by default
[    5.941135] Switched to clocksource hyperv_clocksource
[    6.168496] pnp: PnP ACPI init
[    6.177572] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.178598] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    6.179969] pnp 00:02: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    6.184791] pnp 00:03: [dma 0 disabled]
[    6.185347] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.190092] pnp 00:04: [dma 0 disabled]
[    6.190622] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.196190] pnp 00:05: [dma 2]
[    6.196679] pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.197439] system 00:06: [io  0x01e0-0x01ef] has been reserved
[    6.208736] system 00:06: [io  0x0160-0x016f] has been reserved
[    6.219984] system 00:06: [io  0x0278-0x027f] has been reserved
[    6.231867] system 00:06: [io  0x0378-0x037f] has been reserved
[    6.243097] system 00:06: [io  0x0678-0x067f] has been reserved
[    6.254362] system 00:06: [io  0x0778-0x077f] has been reserved
[    6.266045] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    6.281254] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.287146] system 00:07: [io  0x0400-0x043f] has been reserved
[    6.302142] system 00:07: [io  0x0370-0x0371] has been reserved
[    6.317101] system 00:07: [io  0x0440-0x044f] has been reserved
[    6.332214] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    6.349972] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    6.366955] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.372064] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    6.400704] system 00:08: [mem 0x000c0000-0x000dffff] could not be reserved
[    6.429097] system 00:08: [mem 0x000e0000-0x000fffff] could not be reserved
[    6.457441] system 00:08: [mem 0x00100000-0xf7ffffff] could not be reserved
[    6.485867] system 00:08: [mem 0xfffc0000-0xffffffff] has been reserved
[    6.513986] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    6.517104] pnp: PnP ACPI: found 9 devices
[    6.580324] pci_bus 0000:00: resource 4 [mem 0xfe0000000-0xfffefffff]
[    6.580335] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    6.580343] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    6.580351] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    6.580358] pci_bus 0000:00: resource 8 [mem 0xf8000000-0xfffbffff]
[    6.580788] NET: Registered protocol family 2
[    6.597010] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    6.619253] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    6.643789] TCP: Hash tables configured (established 65536 bind 65536)
[    6.660206] TCP: reno registered
[    6.670476] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[    6.687508] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[    6.706429] NET: Registered protocol family 1
[    6.718480] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.733938] pci 0000:00:08.0: Boot video device
[    6.734002] PCI: CLS 0 bytes, default 64
[    6.734776] Unpacking initramfs...
[    6.997319] debug: unmapping init [mem 0xffff88007fa41000-0xffff88007fffefff]
[    7.314674] DMA-API: preallocated 65536 debug entries
[    7.328985] DMA-API: debugging enabled by kernel config
[    7.342795] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    7.359001] software IO TLB [mem 0xf3ff0000-0xf7ff0000] (64MB) mapped at [ffff8800f3ff0000-ffff8800f7feffff]
[    7.384042] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Joules, 3 fixed counters 10737418240 ms ovfl timer
[    7.413157] AVX version of gcm_enc/dec engaged.
[    7.425493] AES CTR mode by8 optimization enabled
[    7.441564] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    7.477547] alg: No test for crc32 (crc32-pclmul)
[    7.513931] futex hash table entries: 4096 (order: 7, 524288 bytes)
[    7.533035] audit: initializing netlink subsys (disabled)
[    7.547266] audit: type=2000 audit(1409134845.546:1): initialized
[    7.566516] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    7.681018] VFS: Disk quotas dquot_6.5.2
[    7.691198] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.714220] SGI XFS with ACLs, security attributes, no debug enabled
[    7.741760] msgmni has been set to 15889
[    7.753375] SELinux:  Registering netfilter hooks
[    7.758684] alg: No test for stdrng (krng)
[    7.768775] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    7.784850] io scheduler noop registered (default)
[    7.795885] io scheduler deadline registered
[    7.807496] io scheduler cfq registered
[    7.816808] start plist test
[    7.819197] end plist test
[    7.820336] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.833129] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    7.848030] hv_vmbus: registering driver hyperv_fb
[    7.859759] hyperv_fb: Unable to open vmbus channel
[    7.871812] hyperv_fb: Unable to connect to VSP
[    7.884016] hv_vmbus: probe failed for device vmbus_0_5 (4)
[    7.898288] hyperv_fb: probe of vmbus_0_5 failed with error 4
[    7.913643] intel_idle: does not run on family 6 model 45
[    7.915139] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    7.934550] ACPI: Power Button [PWRF]
[    7.947361] GHES: HEST is not enabled!
[    7.958656] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.998089] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    8.040357] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    8.070356] Non-volatile memory driver v1.3
[    8.085729] Linux agpgart interface v0.103
[    8.102106] loop: module loaded
[    8.115269] Loading iSCSI transport class v2.0-870.
[    8.136987] iscsi: registered transport (tcp)
[    8.155965] hv_vmbus: registering driver hv_storvsc
[    8.175681] scsi host0: storvsc_host_t
[    8.199394] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[    8.238774] scsi host1: storvsc_host_t
[    8.257283] scsi 1:0:0:0: scsi scan: INQUIRY result too short (5), using 36
[    8.285018] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.304723] ata_piix 0000:00:07.1: version 2.13
[    8.305453] ata_piix 0000:00:07.1: Hyper-V Virtual Machine detected, ATA device ignore set
[    8.335067] sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
[    8.360291] sd 0:0:0:0: [sda] Write Protect is off
[    8.377238] sd 0:0:0:0: [sda] Mode Sense: 0f 00 00 00
[    8.379237] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.412360] scsi 1:0:0:1: Direct-Access     ADATA    SSD S510 120GB   5.2. PQ: 0 ANSI: 0
[    8.456013]  sda: sda1
[    8.473303] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.529749] scsi host2: ata_piix
[    8.546635] scsi 1:0:0:2: Direct-Access     MDT MD50 00AAKS-00TMA0         PQ: 0 ANSI: 2 CCS
[    8.574612] scsi host3: ata_piix
[    8.588658] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    8.623396] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    8.655040] libphy: Fixed MDIO Bus: probed
[    8.670862] scsi 1:0:0:3: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[    8.698281] hv_vmbus: registering driver hv_netvsc
[    8.729772] scsi 1:0:0:4: Direct-Access              ST1000DM003-9YN1 CC4H PQ: 0 ANSI: 0
[    8.758553] scsi 1:0:0:5: scsi scan: INQUIRY result too short (5), using 36
[    8.782481] hv_netvsc: hv_netvsc channel opened successfully
[    8.833594] scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
[    8.874913] ------------[ cut here ]------------
[    8.889563] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[    8.909984] ret = 19
[    8.917354] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1.x86_64-dirty #129
[    8.936935] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[    8.959705]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[    8.989112]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[    9.018909]  ffff8800f02aab30 000000000000000a ffff8801f7af8348 ffff8801fb1bbb38
[    9.048306] Call Trace:
[    9.056216]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[    9.069571]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[    9.084799]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[    9.099527]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[    9.113601]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[    9.129484]  [<ffffffff814e8e93>] netvsc_device_add+0x583/0x7c0
[    9.144599]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[    9.160382]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[    9.175530]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[    9.190384]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[    9.204006]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[    9.230417]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[    9.256020]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[    9.280750]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[    9.305446]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[    9.328885]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[    9.353273]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[    9.379013]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[    9.403293]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[    9.430294]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[    9.455224]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[    9.479745]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[    9.503409]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[    9.530219]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[    9.554435]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[    9.577875]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[    9.600635]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[    9.624496]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[    9.647234] ---[ end trace f9ad7b9222f87f53 ]---
[    9.671663] scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.703736] scsi 1:1:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.746777] scsi 1:1:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.773567] scsi 1:1:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.800675] ata1.00: host indicates ignore ATA devices, ignored
[    9.804214] scsi 1:1:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.830063] scsi 1:2:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.855760] scsi 1:2:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.881501] scsi 1:2:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.908460] scsi 1:2:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.934736] scsi 1:3:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.960593] scsi 1:3:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.986461] scsi 1:3:1:0: scsi scan: INQUIRY result too short (5), using 36
[   10.012706] scsi 1:3:1:1: scsi scan: INQUIRY result too short (5), using 36
[   10.052451] scsi 1:4:0:0: scsi scan: INQUIRY result too short (5), using 36
[   10.092771] scsi 1:4:0:1: scsi scan: INQUIRY result too short (5), using 36
[   10.133622] scsi 1:4:1:0: scsi scan: INQUIRY result too short (5), using 36
[   10.173833] scsi 1:4:1:1: scsi scan: INQUIRY result too short (5), using 36
[   10.206368] scsi 1:5:0:0: scsi scan: INQUIRY result too short (5), using 36
[   10.228413] scsi 1:5:0:1: scsi scan: INQUIRY result too short (5), using 36
[   10.248960] scsi 1:5:1:0: scsi scan: INQUIRY result too short (5), using 36
[   10.269394] scsi 1:5:1:1: scsi scan: INQUIRY result too short (5), using 36
[   10.289267] ------------[ cut here ]------------
[   10.302016] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   10.322434] ret = 19
[   10.329831] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   10.350717] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   10.373483]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   10.402697]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   10.432026]  ffff8800f02b79f0 000000000000000a ffff8801f7af8348 ffff8801fb1bbb38
[   10.473505] Call Trace:
[   10.481428]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   10.495180]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   10.510446]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   10.525028]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   10.555141]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   10.582090]  [<ffffffff814e8e93>] netvsc_device_add+0x583/0x7c0
[   10.607335]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   10.633685]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   10.659499]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   10.683907]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   10.706712]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   10.732523]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   10.748004]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   10.762616]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   10.777139]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   10.791154]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   10.805594]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   10.820934]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   10.835312]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   10.851036]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   10.865416]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   10.879914]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   10.894034]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   10.909620]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   10.925913]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   10.939534]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   10.953946]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   10.967976]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   10.981619] ---[ end trace f9ad7b9222f87f54 ]---
[   10.995221] scsi 1:6:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.015733] scsi 1:6:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.036310] scsi 1:6:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.056571] scsi 1:6:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.076973] scsi 1:7:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.097992] scsi 1:7:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.118405] scsi 1:7:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.138800] scsi 1:7:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.161474] sd 1:0:0:1: Attached scsi generic sg1 type 0
[   11.178277] sd 1:0:0:1: [sdb] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   11.212448] sd 1:0:0:2: Attached scsi generic sg2 type 0
[   11.239788] sd 1:0:0:3: Attached scsi generic sg3 type 0
[   11.267114] sd 1:0:0:4: Attached scsi generic sg4 type 0
[   11.292278] sd 1:0:0:2: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   11.325921] sd 1:0:0:2: [sdc] Write Protect is off
[   11.357228] sd 1:0:0:2: [sdc] Mode Sense: 0f 00 00 00
[   11.377331] sd 1:0:0:3: [sdd] 199229440 512-byte logical blocks: (102 GB/95.0 GiB)
[   11.397300] sd 1:0:0:4: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   11.416368] sd 1:0:0:1: [sdb] Write Protect is off
[   11.429136] sd 1:0:0:1: [sdb] Mode Sense: 0f 00 00 00
[   11.439448] sd 1:0:0:4: [sde] Write Protect is off
[   11.456700] sd 1:0:0:4: [sde] Mode Sense: 0f 00 00 00
[   11.456739] sd 1:0:0:2: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   11.486290] sd 1:0:0:3: [sdd] Write Protect is off
[   11.503314] sd 1:0:0:3: [sdd] Mode Sense: 0f 00 00 00
[   11.503429] sd 1:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.535297] ------------[ cut here ]------------
[   11.552208] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   11.579239] ret = 19
[   11.588965] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   11.616934] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   11.646598]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   11.686315]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   11.735981]  ffff8800f02b5fb0 000000000000000a ffff8801f7af8348 ffff8801fb1bbb38
[   11.777906] Call Trace:
[   11.788837]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   11.806623]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   11.826680]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   11.846792]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   11.865517]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   11.886195]  [<ffffffff814e8e93>] netvsc_device_add+0x583/0x7c0
[   11.919502]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   11.950080]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   11.970944]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   11.990259]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   12.008749]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   12.028981]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   12.047942]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   12.067101]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   12.086143]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   12.104601]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   12.123592]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   12.144124]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   12.162759]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   12.183389]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   12.202524]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   12.221766]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   12.240738]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   12.261930]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   12.281388]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   12.299316]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   12.317120]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   12.335898]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   12.354373] ---[ end trace f9ad7b9222f87f55 ]---
[   12.370710] sd 1:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.402207] sd 1:0:0:4: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.479401]  sdc: unknown partition table
[   12.498832]  sdd: unknown partition table
[   12.517920]  sdb: sdb1
[   12.554497] sd 1:0:0:2: [sdc] Attached SCSI disk
[   12.572171]  sde: sde1 sde2
[   12.584081] sd 1:0:0:3: [sdd] Attached SCSI disk
[   12.603813] sd 1:0:0:1: [sdb] Attached SCSI disk
[   12.624327] hv_netvsc vmbus_0_13: Send section size: 6144, Section count:2560
[   12.647537] sd 1:0:0:4: [sde] Attached SCSI disk
[   12.664771] hv_netvsc vmbus_0_13: Device MAC 00:15:5d:6f:02:8f link state up
[   12.693324] hv_netvsc: hv_netvsc channel opened successfully
[   12.741241] ------------[ cut here ]------------
[   12.758497] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   12.778827] ret = 19
[   12.786236] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   12.807107] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   12.829836]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   12.860126]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   12.889343]  ffff8800efbe90f0 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   12.918895] Call Trace:
[   12.927029]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   12.940561]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   12.955685]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   12.970318]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   12.984390]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   13.001046]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   13.016092]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   13.032099]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   13.048114]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   13.062246]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   13.075821]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   13.091284]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   13.105594]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   13.120261]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   13.134865]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   13.148850]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   13.163354]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   13.178978]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   13.193241]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   13.208998]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   13.223416]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   13.237859]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   13.251941]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   13.267475]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   13.282950]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   13.296552]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   13.310102]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   13.324570]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   13.338434] ---[ end trace f9ad7b9222f87f56 ]---
[   13.457436] ------------[ cut here ]------------
[   13.474036] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   13.502008] ret = 19
[   13.511878] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   13.539297] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   13.578189]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   13.629450]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   13.681096]  ffff8800efbecf48 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   13.732665] Call Trace:
[   13.743628]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   13.762210]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   13.783944]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   13.803216]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   13.822257]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   13.853590]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   13.881010]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   13.905374]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   13.935875]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   13.954610]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   13.984613]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   14.005083]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   14.025178]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   14.045697]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   14.076541]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   14.094045]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   14.115935]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   14.137132]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   14.167514]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   14.199962]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   14.219601]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   14.239135]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   14.258468]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   14.279271]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   14.310077]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   14.339491]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   14.357200]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   14.386244]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   14.404027] ---[ end trace f9ad7b9222f87f57 ]---
[   14.532490] ------------[ cut here ]------------
[   14.549861] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   14.576904] ret = 19
[   14.587052] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   14.614575] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   14.644705]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   14.695567]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   14.735130]  ffff8800efbf10f0 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   14.783917] Call Trace:
[   14.794440]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   14.812192]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   14.832255]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   14.862170]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   14.881007]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   14.912566]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   14.933127]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   14.962524]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   14.982754]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   15.011380]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   15.029975]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   15.061237]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   15.089007]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   15.108060]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   15.128525]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   15.147542]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   15.167092]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   15.187485]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   15.206517]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   15.238669]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   15.257493]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   15.288081]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   15.306942]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   15.338635]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   15.369542]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   15.387103]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   15.405032]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   15.433125]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   15.451657] ---[ end trace f9ad7b9222f87f58 ]---
[   15.587488] ------------[ cut here ]------------
[   15.604353] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   15.639555] ret = 19
[   15.650030] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   15.689655] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   15.730282]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   15.780973]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   15.830974]  ffff8800efbf4f48 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   15.880582] Call Trace:
[   15.890793]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   15.919324]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   15.939129]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   15.969554]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   15.988800]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   16.020544]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   16.040853]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   16.072086]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   16.092173]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   16.120792]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   16.146850]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   16.169560]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   16.199660]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   16.218797]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   16.248880]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   16.266983]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   16.297707]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   16.317704]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   16.348240]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   16.369679]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   16.398572]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   16.418113]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   16.446824]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   16.479738]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   16.498318]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   16.526323]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   16.543682]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   16.573580]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   16.591173] ---[ end trace f9ad7b9222f87f59 ]---
[   16.708517] ------------[ cut here ]------------
[   16.725962] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   16.753684] ret = 19
[   16.763819] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   16.802877] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   16.845176]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   16.887811]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   16.940155]  ffff8800efbff018 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   16.990411] Call Trace:
[   17.011731]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   17.029217]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   17.050313]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   17.070990]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   17.090009]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   17.120821]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   17.151327]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   17.172371]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   17.203782]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   17.221933]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   17.250760]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   17.270790]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   17.290335]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   17.309930]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   17.339397]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   17.358768]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   17.389243]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   17.409681]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   17.439063]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   17.459890]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   17.489605]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   17.509613]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   17.538489]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   17.559020]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   17.588039]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   17.606594]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   17.634969]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   17.654630]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   17.682240] ---[ end trace f9ad7b9222f87f5a ]---
[   17.795569] ------------[ cut here ]------------
[   17.813252] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   17.850731] ret = 19
[   17.861091] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   17.898981] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   17.940385]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   17.990703]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   18.031796]  ffff8800efbfcf48 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   18.082403] Call Trace:
[   18.092742]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   18.122327]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   18.142687]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   18.173013]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   18.191911]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   18.222935]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   18.244295]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   18.276901]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   18.299344]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   18.320697]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   18.339873]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   18.370191]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   18.389700]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   18.409729]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   18.429956]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   18.448976]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   18.468584]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   18.500237]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   18.520123]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   18.544740]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   18.559237]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   18.573914]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   18.604914]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   18.640001]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   18.662507]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   18.693661]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   18.715393]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   18.747257]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   18.778247] ---[ end trace f9ad7b9222f87f5b ]---
[   18.898582] ------------[ cut here ]------------
[   18.915664] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   18.943242] ret = 19
[   18.953179] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   18.981040] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   19.011507]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   19.063366]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   19.114206]  ffff8800ef4010f0 000000000000000a ffff8800f12ee900 ffff8801fb1bbb38
[   19.164202] Call Trace:
[   19.175053]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   19.203261]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   19.223148]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   19.254337]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   19.273829]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   19.305656]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   19.326662]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   19.348796]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   19.368937]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   19.396856]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   19.415109]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   19.446052]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   19.465357]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   19.495279]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   19.525992]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   19.544257]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   19.564955]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   19.586485]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   19.605398]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   19.636754]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   19.663265]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   19.685003]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   19.715328]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   19.736845]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   19.766805]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   19.785081]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   19.803771]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   19.823645]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   19.842724] ---[ end trace f9ad7b9222f87f5c ]---
[   19.982449] ------------[ cut here ]------------
[   19.995865] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   20.016352] ret = 19
[   20.023755] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   20.044772] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   20.067553]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   20.097129]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   20.138292]  ffff8801f62b0088 000000000000000a ffff8800ef405898 ffff8801fb1bbb38
[   20.185722] Call Trace:
[   20.198694]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   20.230135]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   20.254305]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   20.288293]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   20.310588]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   20.345479]  [<ffffffff814e8e93>] netvsc_device_add+0x583/0x7c0
[   20.379097]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   20.403936]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   20.428431]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   20.450892]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   20.481085]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   20.515714]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   20.538297]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   20.561468]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   20.584477]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   20.617939]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   20.640894]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   20.662662]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   20.677035]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   20.701412]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   20.715955]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   20.730496]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   20.761678]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   20.786497]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   20.809498]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   20.831761]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   20.853300]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   20.876185]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   20.897709] ---[ end trace f9ad7b9222f87f5d ]---
[   21.017658] ------------[ cut here ]------------
[   21.034980] WARNING: CPU: 0 PID: 1 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   21.054717] ret = 19
[   21.059590] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   21.087076] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   21.130723]  0000000000000009 ffff8801fb1bbaa0 ffffffff8169a61b ffff8801fb1bbae8
[   21.171134]  ffff8801fb1bbad8 ffffffff81071338 0000000000000013 00000000000000f0
[   21.211386]  ffff8801f62b5fb0 000000000000000a ffff8800ef405898 ffff8801fb1bbb38
[   21.250260] Call Trace:
[   21.260725]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   21.278751]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   21.299189]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   21.318330]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   21.337008]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   21.357582]  [<ffffffff814e8e93>] netvsc_device_add+0x583/0x7c0
[   21.377862]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   21.398722]  [<ffffffff810ba2d8>] ? lockdep_init_map+0x4c8/0x510
[   21.418648]  [<ffffffff814e76b2>] netvsc_probe+0x192/0x280
[   21.437435]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[   21.456177]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[   21.476483]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[   21.495238]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[   21.514457]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[   21.534087]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[   21.552387]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[   21.572581]  [<ffffffff81d84add>] ? fixed_mdio_bus_init+0xf3/0xf3
[   21.593517]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[   21.612632]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[   21.633447]  [<ffffffff81d84b1c>] netvsc_drv_init+0x3f/0x41
[   21.652976]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   21.672791]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[   21.692071]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   21.712572]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   21.731869]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   21.750685]  [<ffffffff8168d24e>] kernel_init+0xe/0x100
[   21.768893]  [<ffffffff816a313c>] ret_from_fork+0x7c/0xb0
[   21.787710]  [<ffffffff8168d240>] ? rest_init+0xd0/0xd0
[   21.805773] ---[ end trace f9ad7b9222f87f5e ]---
[   21.930058] hv_netvsc vmbus_0_15: Send section size: 6144, Section count:2560
[   21.955340] hv_netvsc vmbus_0_15: Device MAC 00:15:5d:6f:02:a5 link state up
[   21.982440] hv_netvsc vmbus_0_16 (unnamed net_device) (uninitialized): unable to open channel: 4
[   22.010441] hv_netvsc vmbus_0_16 (unnamed net_device) (uninitialized): unable to add netvsc device (ret 4)
[   22.041943] hv_vmbus: probe failed for device vmbus_0_16 (4)
[   22.061806] hv_netvsc: probe of vmbus_0_16 failed with error 4
[   22.082351] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   22.127499] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.157994] serio: i8042 AUX port at 0x60,0x64 irq 12
[   22.177394] hv_vmbus: registering driver hyperv_keyboard
[   22.209997] mousedev: PS/2 mouse device common for all mice
[   22.232582] rtc_cmos 00:00: RTC can wake from S4
[   22.295892] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   22.319222] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   22.350852] rtc_cmos 00:00: alarms up to one month, 114 bytes nvram
[   22.390522] input: AT Translated Set 2 keyboard as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:07/VMBUS:01/vmbus_0_4/serio2/input/input3
[   22.447074] piix4_smbus 0000:00:07.3: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
[   22.487326] device-mapper: uevent: version 1.0.3
[   22.504491] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   22.527176] device-mapper: multipath: version 1.7.0 loaded
[   22.541337] device-mapper: multipath round-robin: version 1.0.0 loaded
[   22.557528] device-mapper: multipath queue-length: version 0.1.0 loaded
[   22.574001] device-mapper: multipath service-time: version 0.2.0 loaded
[   22.627295] hidraw: raw HID events driver (C) Jiri Kosina
[   22.644634] hv_vmbus: registering driver hid_hyperv
[   22.674070] input: Microsoft Vmbus HID-compliant Mouse as /devices/0006:045E:0621.0001/input/input5
[   22.710520] hid-generic 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01 Mouse [Microsoft Vmbus HID-compliant Mouse] on 
[   22.753772] hv_utils: Registering HyperV Utility Driver
[   22.772211] hv_vmbus: registering driver hv_util
[   22.804048] hv_vmbus: registering driver hv_balloon
[   22.822486] drop_monitor: Initializing network drop monitor service
[   22.844495] ip_tables: (C) 2000-2006 Netfilter Core Team
[   22.863076] TCP: cubic registered
[   22.887204] Initializing XFRM netlink socket
[   22.902460] NET: Registered protocol family 17
[   22.925019] registered taskstats version 1
[   22.951604] rtc_cmos 00:00: setting system clock to 2014-08-27 10:21:03 UTC (1409134863)
[   22.994162] debug: unmapping init [mem 0xffffffff81d28000-0xffffffff81e7efff]
[   23.028494] Write protecting the kernel read-only data: 12288k
[   23.049002] debug: unmapping init [mem 0xffff8800016a8000-0xffff8800017fffff]
[   23.072588] debug: unmapping init [mem 0xffff880001a7c000-0xffff880001bfffff]
[   23.139033] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   23.185883] systemd[1]: Detected virtualization 'microsoft'.
[   23.205746] systemd[1]: Running in initial RAM disk.
[   23.248732] systemd[1]: Failed to insert module 'ipv6'
[   23.278803] systemd[1]: Set hostname to <>.
[   23.308664] random: systemd urandom read with 85 bits of entropy available
[   23.409998] psmouse serio1: alps: Unknown ALPS touchpad: E7=12 00 64, EC=12 00 64
[   23.566139] systemd[1]: Expecting device dev-disk-by\x2duuid-e78f2b16\x2d8836\x2d4e6a\x2d9e5e\x2dfdc6c9d3cfc3.device...
[   23.598507] systemd[1]: Starting -.slice.
[   23.622118] systemd[1]: Created slice -.slice.
[   23.631172] systemd[1]: Starting System Slice.
[   23.658586] systemd[1]: Created slice System Slice.
[   23.668315] systemd[1]: Starting Slices.
[   23.699189] systemd[1]: Reached target Slices.
[   23.712929] systemd[1]: Starting Timers.
[   23.751659] systemd[1]: Reached target Timers.
[   23.778291] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   23.817439] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   23.840062] systemd[1]: Starting Paths.
[   23.866491] systemd[1]: Reached target Paths.
[   23.878731] systemd[1]: Starting Journal Socket.
[   23.907625] systemd[1]: Listening on Journal Socket.
[   23.921410] psmouse serio1: trackpoint: failed to get extended button data
[   23.939888] systemd[1]: Started dracut cmdline hook.
[   23.954688] systemd[1]: Started dracut pre-udev hook.
[   23.974047] systemd[1]: Started Load Kernel Modules.
[   23.991483] systemd[1]: Starting Journal Service...
[   24.094037] systemd[1]: Started Journal Service.
[   24.509152] systemd-udevd[134]: starting version 208
[   25.233657] random: nonblocking pool is initialized
[   25.709711] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   26.117082] systemd-journald[128]: Received SIGTERM
[   26.235469] SELinux:  Disabled at runtime.
[   26.240601] SELinux:  Unregistering netfilter hooks
[   26.240720] audit: type=1404 audit(1409134866.788:2): selinux=0 auid=4294967295 ses=4294967295
[   27.393361] EXT4-fs (sda1): re-mounted. Opts: (null)
[   27.506093] systemd-udevd[245]: starting version 208
[   28.783750] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x01, buttons: 0/0
[   28.824258] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[   28.957574] md: bind<sdc>
[   29.082595] md: personality for level -1 is not loaded!
[   29.219311] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   29.371329] systemd-journald[248]: Received request to flush runtime journal from PID 1
[   29.923959] hv_utils: KVP: user-mode registering done.
[   35.211803] hv_netvsc vmbus_0_15: net device safe to remove
[   35.224038] hv_netvsc: hv_netvsc channel opened successfully
[   35.249059] ------------[ cut here ]------------
[   35.256925] WARNING: CPU: 0 PID: 529 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   35.268895] ret = 19
[   35.273124] CPU: 0 PID: 529 Comm: ip Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   35.285737] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   35.302668]  0000000000000009 ffff8801f581b590 ffffffff8169a61b ffff8801f581b5d8
[   35.325474]  ffff8801f581b5c8 ffffffff81071338 0000000000000013 00000000000000f0
[   35.347516]  ffff8801f5c45c68 000000000000000a ffff8801fa3d8000 ffff8801f581b628
[   35.369498] Call Trace:
[   35.375435]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   35.386134]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   35.399151]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   35.411905]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   35.424036]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   35.437473]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   35.450455]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   35.464274]  [<ffffffff810b1450>] ? __wake_up_common+0x90/0x90
[   35.477014]  [<ffffffff814e687c>] netvsc_change_mtu+0x15c/0x1f0
[   35.489943]  [<ffffffff815d1390>] dev_set_mtu+0x80/0x130
[   35.502534]  [<ffffffff815e1885>] do_setlink+0x1b5/0xa60
[   35.514375]  [<ffffffff811a58f1>] ? deactivate_slab+0x1c1/0x500
[   35.527247]  [<ffffffff815e293d>] rtnl_newlink+0x49d/0x760
[   35.539342]  [<ffffffff815e25bf>] ? rtnl_newlink+0x11f/0x760
[   35.551805]  [<ffffffff811a5b6b>] ? deactivate_slab+0x43b/0x500
[   35.564642]  [<ffffffff81010a1b>] ? save_stack_trace+0x2b/0x50
[   35.577301]  [<ffffffff811a29dc>] ? set_track+0x6c/0x190
[   35.589080]  [<ffffffff815dee51>] rtnetlink_rcv_msg+0x221/0x260
[   35.602010]  [<ffffffff810b988d>] ? trace_hardirqs_on+0xd/0x10
[   35.614695]  [<ffffffff815dec0b>] ? rtnetlink_rcv+0x1b/0x40
[   35.626935]  [<ffffffff815dec30>] ? rtnetlink_rcv+0x40/0x40
[   35.639178]  [<ffffffff815fca45>] netlink_rcv_skb+0x65/0xb0
[   35.651526]  [<ffffffff815dec1a>] rtnetlink_rcv+0x2a/0x40
[   35.663565]  [<ffffffff815fab7c>] netlink_unicast+0xcc/0x1a0
[   35.676061]  [<ffffffff815fb97e>] netlink_sendmsg+0x6de/0x750
[   35.689503]  [<ffffffff815b4368>] sock_sendmsg+0x88/0xb0
[   35.703837]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   35.725790]  [<ffffffff811851c3>] ? might_fault+0xa3/0xb0
[   35.747093]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   35.769093]  [<ffffffff815c2c5d>] ? verify_iovec+0x7d/0xf0
[   35.792062]  [<ffffffff815b4776>] ___sys_sendmsg+0x296/0x2b0
[   35.816000]  [<ffffffff8118384d>] ? handle_mm_fault+0x69d/0x12a0
[   35.841065]  [<ffffffff810403e3>] ? __do_page_fault+0x1c3/0x4f0
[   35.865702]  [<ffffffff810b6adf>] ? up_read+0x1f/0x40
[   35.887585]  [<ffffffff8104064c>] ? __do_page_fault+0x42c/0x4f0
[   35.912311]  [<ffffffff811e2445>] ? mntput_no_expire+0x65/0x170
[   35.937177]  [<ffffffff811e23e5>] ? mntput_no_expire+0x5/0x170
[   35.961485]  [<ffffffff811e2cf5>] ? mntput+0x35/0x40
[   35.983054]  [<ffffffff811c3552>] ? __fput+0x1b2/0x1d0
[   36.005507]  [<ffffffff815b5702>] __sys_sendmsg+0x42/0x70
[   36.028628]  [<ffffffff815b573e>] SyS_sendmsg+0xe/0x10
[   36.050759]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b
[   36.075845] ---[ end trace f9ad7b9222f87f60 ]---
[   36.198857] ------------[ cut here ]------------
[   36.220512] WARNING: CPU: 0 PID: 529 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   36.246194] ret = 19
[   36.255672] CPU: 0 PID: 529 Comm: ip Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   36.281289] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   36.310392]  0000000000000009 ffff8801f581b590 ffffffff8169a61b ffff8801f581b5d8
[   36.353141]  ffff8801f581b5c8 ffffffff81071338 0000000000000013 00000000000000f0
[   36.392068]  ffff8801f5c44570 000000000000000a ffff8801fa3d8000 ffff8801f581b628
[   36.433463] Call Trace:
[   36.443821]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   36.461737]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   36.481558]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   36.504087]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   36.523334]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   36.543876]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   36.564185]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   36.585388]  [<ffffffff810b1450>] ? __wake_up_common+0x90/0x90
[   36.607850]  [<ffffffff814e687c>] netvsc_change_mtu+0x15c/0x1f0
[   36.627477]  [<ffffffff815d1390>] dev_set_mtu+0x80/0x130
[   36.646067]  [<ffffffff815e1885>] do_setlink+0x1b5/0xa60
[   36.664134]  [<ffffffff811a58f1>] ? deactivate_slab+0x1c1/0x500
[   36.684363]  [<ffffffff815e293d>] rtnl_newlink+0x49d/0x760
[   36.713612]  [<ffffffff815e25bf>] ? rtnl_newlink+0x11f/0x760
[   36.733499]  [<ffffffff811a5b6b>] ? deactivate_slab+0x43b/0x500
[   36.761498]  [<ffffffff81010a1b>] ? save_stack_trace+0x2b/0x50
[   36.789141]  [<ffffffff811a29dc>] ? set_track+0x6c/0x190
[   36.811650]  [<ffffffff815dee51>] rtnetlink_rcv_msg+0x221/0x260
[   36.841504]  [<ffffffff810b988d>] ? trace_hardirqs_on+0xd/0x10
[   36.862173]  [<ffffffff815dec0b>] ? rtnetlink_rcv+0x1b/0x40
[   36.892453]  [<ffffffff815dec30>] ? rtnetlink_rcv+0x40/0x40
[   36.911874]  [<ffffffff815fca45>] netlink_rcv_skb+0x65/0xb0
[   36.931517]  [<ffffffff815dec1a>] rtnetlink_rcv+0x2a/0x40
[   36.950737]  [<ffffffff815fab7c>] netlink_unicast+0xcc/0x1a0
[   36.971605]  [<ffffffff815fb97e>] netlink_sendmsg+0x6de/0x750
[   36.991621]  [<ffffffff815b4368>] sock_sendmsg+0x88/0xb0
[   37.009824]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   37.037371]  [<ffffffff811851c3>] ? might_fault+0xa3/0xb0
[   37.056036]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   37.085418]  [<ffffffff815c2c5d>] ? verify_iovec+0x7d/0xf0
[   37.103866]  [<ffffffff815b4776>] ___sys_sendmsg+0x296/0x2b0
[   37.133431]  [<ffffffff8118384d>] ? handle_mm_fault+0x69d/0x12a0
[   37.153788]  [<ffffffff810403e3>] ? __do_page_fault+0x1c3/0x4f0
[   37.174494]  [<ffffffff810b6adf>] ? up_read+0x1f/0x40
[   37.192098]  [<ffffffff8104064c>] ? __do_page_fault+0x42c/0x4f0
[   37.220404]  [<ffffffff811e2445>] ? mntput_no_expire+0x65/0x170
[   37.240237]  [<ffffffff811e23e5>] ? mntput_no_expire+0x5/0x170
[   37.270137]  [<ffffffff811e2cf5>] ? mntput+0x35/0x40
[   37.287672]  [<ffffffff811c3552>] ? __fput+0x1b2/0x1d0
[   37.316237]  [<ffffffff815b5702>] __sys_sendmsg+0x42/0x70
[   37.334613]  [<ffffffff815b573e>] SyS_sendmsg+0xe/0x10
[   37.363255]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b
[   37.383144] ---[ end trace f9ad7b9222f87f61 ]---
[   37.591869] ------------[ cut here ]------------
[   37.611035] WARNING: CPU: 0 PID: 529 at drivers/hv/connection.c:436 vmbus_post_msg+0x59/0xa0()
[   37.637831] ret = 19
[   37.647309] CPU: 0 PID: 529 Comm: ip Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   37.677560] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   37.707708]  0000000000000009 ffff8801f581b590 ffffffff8169a61b ffff8801f581b5d8
[   37.747802]  ffff8801f581b5c8 ffffffff81071338 0000000000000013 00000000000000f0
[   37.787656]  ffff8800eee131c0 000000000000000a ffff8801fa3d8000 ffff8801f581b628
[   37.828683] Call Trace:
[   37.839579]  [<ffffffff8169a61b>] dump_stack+0x4d/0x66
[   37.857638]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[   37.877214]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[   37.896804]  [<ffffffff815a84b9>] vmbus_post_msg+0x59/0xa0
[   37.915818]  [<ffffffff815a8d44>] vmbus_establish_gpadl+0x334/0x450
[   37.938174]  [<ffffffff814e8cf2>] netvsc_device_add+0x3e2/0x7c0
[   37.957895]  [<ffffffff814ea160>] rndis_filter_device_add+0x80/0x430
[   37.979115]  [<ffffffff810b1450>] ? __wake_up_common+0x90/0x90
[   38.001605]  [<ffffffff814e687c>] netvsc_change_mtu+0x15c/0x1f0
[   38.022521]  [<ffffffff815d1390>] dev_set_mtu+0x80/0x130
[   38.041474]  [<ffffffff815e1885>] do_setlink+0x1b5/0xa60
[   38.059663]  [<ffffffff811a58f1>] ? deactivate_slab+0x1c1/0x500
[   38.079436]  [<ffffffff815e293d>] rtnl_newlink+0x49d/0x760
[   38.098218]  [<ffffffff815e25bf>] ? rtnl_newlink+0x11f/0x760
[   38.117302]  [<ffffffff811a5b6b>] ? deactivate_slab+0x43b/0x500
[   38.150519]  [<ffffffff81010a1b>] ? save_stack_trace+0x2b/0x50
[   38.170943]  [<ffffffff811a29dc>] ? set_track+0x6c/0x190
[   38.190722]  [<ffffffff815dee51>] rtnetlink_rcv_msg+0x221/0x260
[   38.210946]  [<ffffffff810b988d>] ? trace_hardirqs_on+0xd/0x10
[   38.230428]  [<ffffffff815dec0b>] ? rtnetlink_rcv+0x1b/0x40
[   38.249183]  [<ffffffff815dec30>] ? rtnetlink_rcv+0x40/0x40
[   38.267917]  [<ffffffff815fca45>] netlink_rcv_skb+0x65/0xb0
[   38.286739]  [<ffffffff815dec1a>] rtnetlink_rcv+0x2a/0x40
[   38.305117]  [<ffffffff815fab7c>] netlink_unicast+0xcc/0x1a0
[   38.337038]  [<ffffffff815fb97e>] netlink_sendmsg+0x6de/0x750
[   38.356571]  [<ffffffff815b4368>] sock_sendmsg+0x88/0xb0
[   38.375320]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   38.394168]  [<ffffffff811851c3>] ? might_fault+0xa3/0xb0
[   38.414002]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   38.432421]  [<ffffffff815c2c5d>] ? verify_iovec+0x7d/0xf0
[   38.451017]  [<ffffffff815b4776>] ___sys_sendmsg+0x296/0x2b0
[   38.481626]  [<ffffffff8118384d>] ? handle_mm_fault+0x69d/0x12a0
[   38.502701]  [<ffffffff810403e3>] ? __do_page_fault+0x1c3/0x4f0
[   38.523029]  [<ffffffff810b6adf>] ? up_read+0x1f/0x40
[   38.540350]  [<ffffffff8104064c>] ? __do_page_fault+0x42c/0x4f0
[   38.571325]  [<ffffffff811e2445>] ? mntput_no_expire+0x65/0x170
[   38.591490]  [<ffffffff811e23e5>] ? mntput_no_expire+0x5/0x170
[   38.611908]  [<ffffffff811e2cf5>] ? mntput+0x35/0x40
[   38.629111]  [<ffffffff811c3552>] ? __fput+0x1b2/0x1d0
[   38.647642]  [<ffffffff815b5702>] __sys_sendmsg+0x42/0x70
[   38.666374]  [<ffffffff815b573e>] SyS_sendmsg+0xe/0x10
[   38.685197]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b
[   38.705459] ---[ end trace f9ad7b9222f87f62 ]---
[   38.912134] hv_netvsc vmbus_0_15 eth1: unable to establish send buffer's gpadl
[   38.991028] hv_netvsc vmbus_0_15 eth1: unable to connect to NetVSP - 4
[   39.066231] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[   39.066794] CPU: 0 PID: 539 Comm: ip Tainted: G        W      3.17.0-rc1.x86_64-dirty #129
[   39.066794] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   39.066794] task: ffff8801f5e69350 ti: ffff8800eef44000 task.ti: ffff8800eef44000
[   39.066794] RIP: 0010:[<ffffffff814ea52f>]  [<ffffffff814ea52f>] rndis_filter_open+0x1f/0x60
[   39.066794] RSP: 0018:ffff8800eef47780  EFLAGS: 00010246
[   39.066794] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000006
[   39.066794] RDX: 0000000000000006 RSI: ffff8801f5e69a90 RDI: ffff8801fa9034d0
[   39.066794] RBP: ffff8800eef47788 R08: 0000000000000000 R09: 0000000000000000
[   39.066794] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8801fa9034d0
[   39.066794] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[   39.066794] FS:  00007f03d4bc3740(0000) GS:ffff880206c00000(0000) knlGS:0000000000000000
[   39.066794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.066794] CR2: 00007fff63399c50 CR3: 00000000efaa8000 CR4: 00000000000406f0
[   39.066794] Stack:
[   39.066794]  ffff8801f81b22a0 ffff8800eef477b0 ffffffff814e6a45 ffff8801f81b22a0
[   39.066794]  ffffffff8188f980 0000000000000000 ffff8800eef477d8 ffffffff815d0f08
[   39.066794]  ffff8801f81b22a0 ffff8801f81b22a0 0000000000001003 ffff8800eef47810
[   39.066794] Call Trace:
[   39.066794]  [<ffffffff814e6a45>] netvsc_open+0x25/0xb0
[   39.066794]  [<ffffffff815d0f08>] __dev_open+0x98/0x110
[   39.066794]  [<ffffffff815d1209>] __dev_change_flags+0xb9/0x160
[   39.066794]  [<ffffffff815d12d9>] dev_change_flags+0x29/0x60
[   39.066794]  [<ffffffff815e19a5>] do_setlink+0x2d5/0xa60
[   39.066794]  [<ffffffff811a58f1>] ? deactivate_slab+0x1c1/0x500
[   39.066794]  [<ffffffff815e293d>] rtnl_newlink+0x49d/0x760
[   39.066794]  [<ffffffff815e25bf>] ? rtnl_newlink+0x11f/0x760
[   39.066794]  [<ffffffff811a5b6b>] ? deactivate_slab+0x43b/0x500
[   39.066794]  [<ffffffff81010a1b>] ? save_stack_trace+0x2b/0x50
[   39.066794]  [<ffffffff811a29dc>] ? set_track+0x6c/0x190
[   39.066794]  [<ffffffff815dee51>] rtnetlink_rcv_msg+0x221/0x260
[   39.066794]  [<ffffffff810b988d>] ? trace_hardirqs_on+0xd/0x10
[   39.066794]  [<ffffffff815dec0b>] ? rtnetlink_rcv+0x1b/0x40
[   39.066794]  [<ffffffff815dec30>] ? rtnetlink_rcv+0x40/0x40
[   39.066794]  [<ffffffff815fca45>] netlink_rcv_skb+0x65/0xb0
[   39.066794]  [<ffffffff815dec1a>] rtnetlink_rcv+0x2a/0x40
[   39.066794]  [<ffffffff815fab7c>] netlink_unicast+0xcc/0x1a0
[   39.066794]  [<ffffffff815fb97e>] netlink_sendmsg+0x6de/0x750
[   39.066794]  [<ffffffff815b4368>] sock_sendmsg+0x88/0xb0
[   39.066794]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   39.066794]  [<ffffffff811851c3>] ? might_fault+0xa3/0xb0
[   39.066794]  [<ffffffff8118517a>] ? might_fault+0x5a/0xb0
[   39.066794]  [<ffffffff815c2c5d>] ? verify_iovec+0x7d/0xf0
[   39.066794]  [<ffffffff815b4776>] ___sys_sendmsg+0x296/0x2b0
[   39.066794]  [<ffffffff8118384d>] ? handle_mm_fault+0x69d/0x12a0
[   39.066794]  [<ffffffff810403e3>] ? __do_page_fault+0x1c3/0x4f0
[   39.066794]  [<ffffffff810b6adf>] ? up_read+0x1f/0x40
[   39.066794]  [<ffffffff8104064c>] ? __do_page_fault+0x42c/0x4f0
[   39.066794]  [<ffffffff811e2445>] ? mntput_no_expire+0x65/0x170
[   39.066794]  [<ffffffff811e23e5>] ? mntput_no_expire+0x5/0x170
[   39.066794]  [<ffffffff811e2cf5>] ? mntput+0x35/0x40
[   39.066794]  [<ffffffff811c3552>] ? __fput+0x1b2/0x1d0
[   39.066794]  [<ffffffff815b5702>] __sys_sendmsg+0x42/0x70
[   39.066794]  [<ffffffff815b573e>] SyS_sendmsg+0xe/0x10
[   39.066794]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b
[   39.066794] Code: 41 5e 41 5f 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 48 8b 87 20 01 00 00 48 85 c0 74 2f 55 48 89 e5 53 48 8b 98 40 02 00 00 31 c0 <83> 7b 08 02 75 2b be 0d 00 00 00 48 89 df e8 9e f9 ff ff 85 c0 
[   39.066794] RIP  [<ffffffff814ea52f>] rndis_filter_open+0x1f/0x60
[   39.066794]  RSP <ffff8800eef47780>
[   40.354724] ---[ end trace f9ad7b9222f87f63 ]---

-- 
Sitsofe | http://sucs.org/~sits/
