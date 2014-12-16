Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaLPOKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:10:06 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47725 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaLPOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:09:58 -0500
Date: Tue, 16 Dec 2014 06:09:52 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216140952.GA1224@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216132821.GA22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro,

On Tue, Dec 16, 2014 at 01:28:21PM +0000, Al Viro wrote:
> On Tue, Dec 16, 2014 at 12:56:15PM +0000, Al Viro wrote:
> > On Tue, Dec 16, 2014 at 03:55:37AM -0800, Jeremiah Mahler wrote:
> > > all,
> > > 
> > > The wireless network interface has become inoperative when running
> > > linux-next 20141216 on a Lenovo Carbon X1.  It is completely
> > > non-existent and `ip addr` doesn't show it.  A bisect has found that
> > > the bug was introduced by the following commit.
> > 
> > Very interesting.  What userland are you running?  I take it, the root
> > filesystem is mounted and system boot except for that interface not
> > coming up, right?
> > 
> > Your card is normally handled by what, iwlwifi?  What happens upon
> > modprobe iwlwifi (or whatever module you see loaded on the normal
> > boot)?  Another interesting question is whether it manages to load
> > the firmware...  What happens if you boot with debug in kernel command
> > line, with working and with non-working kernels resp.?
> 
> Hmm...  OK, I think I see what might be going on.  On the testbox here
> I've got pivot_root(2) done from /init on initramfs.  And that triggers
> chroot_fs_refs(), which switches init_fs.{root,pwd} to the final rootfs.
> In your case it apparently isn't triggered (different userland or setup,
> perhaps) and init_fs is left behind on initramfs.  With some files
> (firmware?) not being there...  Could you check if the following kludge
> helps?  It's not intended as a solution, I just want to verify that guess
> about the mechanism of the problem...
> 
> diff --git a/init/main.c b/init/main.c
> index 3a169a2..36c29d6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -80,6 +80,8 @@
>  #include <linux/list.h>
>  #include <linux/proc_ns.h>
>  #include <linux/fs_struct.h>
> +#include "../fs/internal.h" // HACK
> +#include <linux/init_task.h> // HACK
>  
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -1024,6 +1026,15 @@ static noinline void __init kernel_init_freeable(void)
>  	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
>  		ramdisk_execute_command = NULL;
>  		prepare_namespace();
> +		{
> +		/* HACK */
> +			struct path old, new;
> +			get_fs_root(current->fs, &new);
> +			get_fs_root(&init_fs, &old);
> +			chroot_fs_refs(&old, &new);
> +			path_put(&old);
> +			path_put(&new);
> +		}
>  	}
>  
>  	/*

I tested the bad commit with your patch applied but it made no
difference, the wireless is still down.

Not sure if it helps, but the dmesg is included below.  There are errors
about not being able to load the firmware that look interesting.

[    0.000000] CPU0 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc6+ (jeri@hudson) (gcc version 4.9.2 (Debian 4.9.2-7) ) #203 SMP Tue Dec 16 05:57:50 PST 2014
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
[    0.000000] tsc: Detected 2494.307 MHz processor
[    0.000044] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.61 BogoMIPS (lpj=9977228)
[    0.000047] pid_max: default: 32768 minimum: 301
[    0.000057] ACPI: Core revision 20140926
[    0.016124] ACPI: All ACPI Tables successfully acquired
[    0.017080] Security Framework initialized
[    0.017089] AppArmor: AppArmor disabled by boot time parameter
[    0.017090] Yama: becoming mindful.
[    0.017406] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.018694] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.019276] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.019284] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.019547] Initializing cgroup subsys devices
[    0.019551] Initializing cgroup subsys freezer
[    0.019554] Initializing cgroup subsys net_cls
[    0.019557] Initializing cgroup subsys blkio
[    0.019559] Initializing cgroup subsys perf_event
[    0.019563] Initializing cgroup subsys net_prio
[    0.019596] CPU: Physical Processor ID: 0
[    0.019597] CPU: Processor Core ID: 0
[    0.019602] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.020091] mce: CPU supports 7 MCE banks
[    0.020104] CPU0: Thermal monitoring enabled (TM1)
[    0.020114] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.020247] Freeing SMP alternatives memory: 20K (ffffffff81a35000 - ffffffff81a3a000)
[    0.021294] ftrace: allocating 21491 entries in 84 pages
[    0.032583] dmar: Host address width 36
[    0.032585] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.032592] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.032593] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.032598] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.032599] dmar: RMRR base: 0x000000da3ba000 end: 0x000000da3d0fff
[    0.032601] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.032676] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.032678] HPET id 0 under DRHD base 0xfed91000
[    0.032679] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.032856] Enabled IRQ remapping in x2apic mode
[    0.032858] Enabling x2apic
[    0.032859] Enabled x2apic
[    0.032867] Switched APIC routing to cluster x2apic.
[    0.033334] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073063] smpboot: CPU0: Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz (fam: 06, model: 3a, stepping: 09)
[    0.073075] TSC deadline timer enabled
[    0.073103] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.073127] ... version:                3
[    0.073129] ... bit width:              48
[    0.073130] ... generic registers:      4
[    0.073131] ... value mask:             0000ffffffffffff
[    0.073132] ... max period:             0000ffffffffffff
[    0.073133] ... fixed-purpose events:   3
[    0.073134] ... event mask:             000000070000000f
[    0.074781] x86: Booting SMP configuration:
[    0.074784] .... node  #0, CPUs:      #1
[    0.088558] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.088672]  #2
[    0.100078] CPU2 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.102854]  #3
[    0.116437] x86: Booted up 1 node, 4 CPUs
[    0.116441] smpboot: Total of 4 processors activated (19954.45 BogoMIPS)
[    0.121221] devtmpfs: initialized
[    0.124206] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.125357] pinctrl core: initialized pinctrl subsystem
[    0.125485] NET: Registered protocol family 16
[    0.137025] cpuidle: using governor ladder
[    0.146828] cpuidle: using governor menu
[    0.146901] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.146903] ACPI: bus type PCI registered
[    0.146905] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.147112] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.147115] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.147209] PCI: Using configuration type 1 for base access
[    0.157592] ACPI: Added _OSI(Module Device)
[    0.157595] ACPI: Added _OSI(Processor Device)
[    0.157596] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.157598] ACPI: Added _OSI(Processor Aggregator Device)
[    0.159426] ACPI : EC: EC description table is found, configuring boot EC
[    0.164959] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.213927] ACPI: Dynamic OEM Table Load:
[    0.213946] ACPI: SSDT 0xFFFF88011901D000 000A01 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.229515] ACPI: Dynamic OEM Table Load:
[    0.229532] ACPI: SSDT 0xFFFF880119732000 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.239116] ACPI: Dynamic OEM Table Load:
[    0.239131] ACPI: SSDT 0xFFFF880119060E00 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.250018] ACPI: Interpreter enabled
[    0.250025] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.250030] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.250046] ACPI: (supports S0 S3 S4 S5)
[    0.250048] ACPI: Using IOAPIC for interrupt routing
[    0.250078] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.261774] ACPI: Power Resource [PUBS] (on)
[    0.262462] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.263533] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.266554] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.266659] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
[    0.266761] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.266858] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 9 10 11)
[    0.266939] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.267039] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11)
[    0.267140] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.267242] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.267354] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.267360] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.267499] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.267561] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.267564] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.267566] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.267568] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.267763] PCI host bridge to bus 0000:00
[    0.267766] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.267769] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.267771] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.267773] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.267775] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.267777] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.267785] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.267890] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.267903] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.267911] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.267916] pci 0000:00:02.0: reg 0x20: [io  0x4000-0x403f]
[    0.268036] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.268062] pci 0000:00:14.0: reg 0x10: [mem 0xf1500000-0xf150ffff 64bit]
[    0.268144] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.268181] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.268244] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.268270] pci 0000:00:16.0: reg 0x10: [mem 0xf1515000-0xf151500f 64bit]
[    0.268357] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.268448] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.268469] pci 0000:00:16.3: reg 0x10: [io  0x4090-0x4097]
[    0.268481] pci 0000:00:16.3: reg 0x14: [mem 0xf151b000-0xf151bfff]
[    0.268647] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.268672] pci 0000:00:1a.0: reg 0x10: [mem 0xf151a000-0xf151a3ff]
[    0.268773] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.268811] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.268870] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.268890] pci 0000:00:1b.0: reg 0x10: [mem 0xf1510000-0xf1513fff 64bit]
[    0.268976] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.269020] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.269080] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.269220] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.269326] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.269473] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.269521] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.269593] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.269617] pci 0000:00:1d.0: reg 0x10: [mem 0xf1519000-0xf15193ff]
[    0.269719] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.269758] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.269814] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    0.270007] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.270029] pci 0000:00:1f.2: reg 0x10: [io  0x4088-0x408f]
[    0.270040] pci 0000:00:1f.2: reg 0x14: [io  0x409c-0x409f]
[    0.270048] pci 0000:00:1f.2: reg 0x18: [io  0x4080-0x4087]
[    0.270057] pci 0000:00:1f.2: reg 0x1c: [io  0x4098-0x409b]
[    0.270067] pci 0000:00:1f.2: reg 0x20: [io  0x4060-0x407f]
[    0.270076] pci 0000:00:1f.2: reg 0x24: [mem 0xf1518000-0xf15187ff]
[    0.270129] pci 0000:00:1f.2: PME# supported from D3hot
[    0.270215] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.270233] pci 0000:00:1f.3: reg 0x10: [mem 0xf1514000-0xf15140ff 64bit]
[    0.270256] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.270619] pci 0000:02:00.0: [1180:e822] type 00 class 0x088001
[    0.270643] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.270671] pci 0000:02:00.0: reg 0x10: [mem 0xf0d00000-0xf0d000ff]
[    0.270914] pci 0000:02:00.0: supports D1 D2
[    0.270916] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.277591] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.277597] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.277602] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.277611] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.277869] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.278071] pci 0000:03:00.0: reg 0x10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.278881] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.285541] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.285550] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.286845] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.286921] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.287053] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.287056] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.287059] vgaarb: loaded
[    0.287060] vgaarb: bridge control possible 0000:00:02.0
[    0.287136] PCI: Using ACPI for IRQ routing
[    0.288871] PCI: pci_cache_line_size set to 64 bytes
[    0.289239] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.289241] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.289242] e820: reserve RAM buffer [mem 0xced49000-0xcfffffff]
[    0.289244] e820: reserve RAM buffer [mem 0x11e600000-0x11fffffff]
[    0.289422] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.289428] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.291465] Switched to clocksource hpet
[    0.298995] pnp: PnP ACPI init
[    0.299518] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.299521] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.299523] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.299525] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.299527] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.299530] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.299532] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.299534] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.299536] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.299538] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.299541] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.299543] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.299545] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.299547] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.299549] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.299552] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.299554] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.299558] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.299660] pnp 00:01: [Firmware Bug]: PNP resource [mem 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending to [mem 0xfed10000-0xfed17fff]
[    0.299686] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.299688] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.299691] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.299693] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.299695] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.299698] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.299700] system 00:01: [mem 0xfffff000-0xffffffff] has been reserved
[    0.299703] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.299705] system 00:01: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.299707] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.299710] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.299712] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.299715] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299790] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.299830] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.299867] pnp 00:04: Plug and Play ACPI device, IDs LEN0030 PNP0f13 (active)
[    0.299925] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.300397] pnp: PnP ACPI: found 6 devices
[    0.307736] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.307744] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.307751] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.307757] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.307766] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.307773] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.307786] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.307788] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.307790] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.307792] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.307794] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.307796] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.307798] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.307800] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.307802] pci_bus 0000:03: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.307870] NET: Registered protocol family 2
[    0.308079] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.308209] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.308480] TCP: Hash tables configured (established 32768 bind 32768)
[    0.308500] TCP: reno registered
[    0.308515] UDP hash table entries: 2048 (order: 5, 196608 bytes)
[    0.308579] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
[    0.308715] NET: Registered protocol family 1
[    0.308732] pci 0000:00:02.0: Video device with shadowed ROM
[    0.309267] PCI: CLS 64 bytes, default 64
[    0.309319] Unpacking initramfs...
[    0.780435] Freeing initrd memory: 22800K (ffff880035368000 - ffff8800369ac000)
[    0.780476] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.780478] software IO TLB [mem 0xcad49000-0xced49000] (64MB) mapped at [ffff8800cad49000-ffff8800ced48fff]
[    0.780759] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.780891] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x1b
[    0.780901] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x1b
[    0.780912] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x1b
[    0.780922] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x1b
[    0.780987] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.781370] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.781434] audit: initializing netlink subsys (disabled)
[    0.781453] audit: type=2000 audit(1418713133.772:1): initialized
[    0.781928] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.781955] zpool: loaded
[    0.781958] zbud: loaded
[    0.782148] VFS: Disk quotas dquot_6.5.2
[    0.782173] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.782244] msgmni has been set to 7323
[    0.782731] alg: No test for stdrng (krng)
[    0.782775] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.782837] io scheduler noop registered
[    0.782844] io scheduler deadline registered
[    0.782864] io scheduler cfq registered (default)
[    0.783258] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.783279] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.783339] intel_idle: MWAIT substates: 0x21120
[    0.783341] intel_idle: v0.4 model 0x3A
[    0.783342] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.783634] GHES: HEST is not enabled!
[    0.783726] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.804532] serial 0000:00:16.3: ttyS0 at I/O 0x4090 (irq = 19, base_baud = 115200) is a 16550A
[    0.804796] Linux agpgart interface v0.103
[    0.804933] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.807213] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.807219] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.807444] mousedev: PS/2 mouse device common for all mice
[    0.807502] rtc_cmos 00:02: RTC can wake from S4
[    0.807710] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.807744] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.807762] Intel P-state driver initializing.
[    0.808109] ledtrig-cpu: registered to indicate activity on CPUs
[    0.808867] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.809935] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.809938] AMD IOMMUv2 functionality not available on this system
[    0.810174] TCP: cubic registered
[    0.810324] NET: Registered protocol family 10
[    0.810949] mip6: Mobile IPv6
[    0.810959] NET: Registered protocol family 17
[    0.810974] mpls_gso: MPLS GSO support
[    0.812156] registered taskstats version 1
[    0.813695] rtc_cmos 00:02: setting system clock to 2014-12-16 06:58:54 UTC (1418713134)
[    0.816090] Freeing unused kernel memory: 1212K (ffffffff81906000 - ffffffff81a35000)
[    0.816106] Write protecting the kernel read-only data: 8192k
[    0.820481] Freeing unused kernel memory: 812K (ffff880001535000 - ffff880001600000)
[    0.821734] Freeing unused kernel memory: 232K (ffff8800017c6000 - ffff880001800000)
[    0.842608] systemd-udevd[74]: starting version 215
[    0.843301] random: systemd-udevd urandom read with 4 bits of entropy available
[    0.863423] thermal LNXTHERM:00: registered as thermal_zone0
[    0.863426] ACPI: Thermal Zone [THM0] (60 C)
[    0.864070] sdhci: Secure Digital Host Controller Interface driver
[    0.864072] sdhci: Copyright(c) Pierre Ossman
[    0.864444] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e822] (rev 7)
[    0.864827] sdhci-pci 0000:02:00.0: No vmmc regulator found
[    0.864829] sdhci-pci 0000:02:00.0: No vqmmc regulator found
[    0.866291] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    0.869384] SCSI subsystem initialized
[    0.871038] libata version 3.00 loaded.
[    0.871902] ahci 0000:00:1f.2: version 3.0
[    0.872018] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    0.872059] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    0.872061] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.873823] scsi host0: ahci
[    0.873930] scsi host1: ahci
[    0.874261] scsi host2: ahci
[    0.874493] scsi host3: ahci
[    0.874746] scsi host4: ahci
[    0.874874] scsi host5: ahci
[    0.875028] ata1: SATA max UDMA/133 abar m2048@0xf1518000 port 0xf1518100 irq 26
[    0.875030] ata2: DUMMY
[    0.875032] ata3: DUMMY
[    0.875033] ata4: DUMMY
[    0.875034] ata5: DUMMY
[    0.875035] ata6: DUMMY
[    1.192660] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.193347] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.193358] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.197062] ata1.00: ATA-8: SanDisk SD5SG2256G1052E, 10.02.01, max UDMA/133
[    1.197070] ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.197844] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.197854] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.198918] ata1.00: configured for UDMA/133
[    1.199434] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SD5SG225 2.01 PQ: 0 ANSI: 5
[    1.207402] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.207681] sd 0:0:0:0: [sda] Write Protect is off
[    1.207689] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.207767] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.209221]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.210400] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.211893] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.275813] PM: Starting manual resume from disk
[    1.330807] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    1.521380] systemd[1]: RTC configured in localtime, applying delta of -480 minutes to system time.
[    1.717865] systemd[1]: Cannot add dependency job for unit slcand.service, ignoring: Unit slcand.service failed to load: No such file or directory.
[    1.752743] fuse init (API version 7.23)
[    1.759866] loop: module loaded
[    1.781191] tsc: Refined TSC clocksource calibration: 2494.340 MHz
[    1.795497] systemd-udevd[200]: starting version 215
[    1.886385] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,discard
[    2.014428] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    2.014559] ACPI: Lid Switch [LID]
[    2.017653] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    2.017659] ACPI: Sleep Button [SLPB]
[    2.017727] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    2.017730] ACPI: Power Button [PWRF]
[    2.040825] ACPI: AC Adapter [AC] (on-line)
[    2.041562] mei_me 0000:00:16.0: irq 27 for MSI/MSI-X
[    2.048392] ACPI: Battery Slot [BAT0] (battery present)
[    2.051532] Non-volatile memory driver v1.3
[    2.052209] wmi: Mapper loaded
[    2.052744] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\_SB_.PCI0.LPC_.PMIO) (20140926/utaddress-258)
[    2.052749] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.052754] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.052757] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.052759] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.052763] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.052764] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    2.052768] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.052769] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    2.055791] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.058682] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    2.061894] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    2.067342] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    2.068798] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    2.068800] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.068801] thinkpad_acpi: ThinkPad BIOS G6ET59WW (2.03 ), EC unknown
[    2.068802] thinkpad_acpi: Lenovo ThinkPad X1 Carbon, model 3443CTO
[    2.069130] thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
[    2.069299] thinkpad_acpi: radio switch found; radios are enabled
[    2.069408] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    2.069410] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    2.070977] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    2.071430] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    2.072870] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    2.074917] ACPI: bus type USB registered
[    2.074942] usbcore: registered new interface driver usbfs
[    2.074952] usbcore: registered new interface driver hub
[    2.075087] usbcore: registered new device driver usb
[    2.089466] [drm] Initialized drm 1.1.0 20060810
[    2.112294] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.112304] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.112412] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.112439] xhci_hcd 0000:00:14.0: irq 28 for MSI/MSI-X
[    2.112652] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.112654] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.112655] usb usb1: Product: xHCI Host Controller
[    2.112656] usb usb1: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.112657] usb usb1: SerialNumber: 0000:00:14.0
[    2.112808] hub 1-0:1.0: USB hub found
[    2.112820] hub 1-0:1.0: 4 ports detected
[    2.114176] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.114181] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.114218] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.114220] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.114222] usb usb2: Product: xHCI Host Controller
[    2.114223] usb usb2: Manufacturer: Linux 3.18.0-rc6+ xhci-hcd
[    2.114225] usb usb2: SerialNumber: 0000:00:14.0
[    2.114393] hub 2-0:1.0: USB hub found
[    2.114404] hub 2-0:1.0: 4 ports detected
[    2.114645] usb: failed to peer usb2-port2 and usb1-port1 by location (usb2-port2:none) (usb1-port1:usb2-port1)
[    2.114647] usb usb2-port2: failed to peer to usb1-port1 (-16)
[    2.114648] usb: port power management may be unreliable
[    2.114725] usb: failed to peer usb2-port3 and usb1-port1 by location (usb2-port3:none) (usb1-port1:usb2-port1)
[    2.114727] usb usb2-port3: failed to peer to usb1-port1 (-16)
[    2.114832] usb: failed to peer usb2-port4 and usb1-port1 by location (usb2-port4:none) (usb1-port1:usb2-port1)
[    2.114834] usb usb2-port4: failed to peer to usb1-port1 (-16)
[    2.122209] iTCO_vendor_support: vendor-support=0
[    2.125726] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.125765] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    2.125880] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.134372] AVX version of gcm_enc/dec engaged.
[    2.134374] AES CTR mode by8 optimization enabled
[    2.134924] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.137633] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    2.167612] alg: No test for crc32 (crc32-pclmul)
[    2.172968] snd_hda_intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    2.178633] Adding 3785724k swap on /dev/sda7.  Priority:-1 extents:1 across:3785724k SSFS
[    2.181923] sound hdaudioC0D0: No codec parser is available
[    2.182226] sound hdaudioC0D3: No codec parser is available
[    2.193044] cfg80211: Calling CRDA to update world regulatory domain
[    2.242699] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    2.242702] Copyright(c) 2003- 2014 Intel Corporation
[    2.242862] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.243029] iwlwifi 0000:03:00.0: irq 30 for MSI/MSI-X
[    2.243157] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-6.ucode failed with error -2
[    2.243166] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-5.ucode failed with error -2
[    2.243168] iwlwifi 0000:03:00.0: request for firmware file 'iwlwifi-6000g2a-5.ucode' failed.
[    2.243242] iwlwifi 0000:03:00.0: no suitable firmware found!
[    2.267881] cfg80211: World regulatory domain updated:
[    2.267885] cfg80211:  DFS Master region: unset
[    2.267886] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.267887] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.267889] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.267890] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.267891] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    2.267892] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.267894] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.267895] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.267897] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.280977] EXT4-fs (sda5): mounting ext2 file system using the ext4 subsystem
[    2.285652] EXT4-fs (sda5): mounted filesystem without journal. Opts: (null)
[    2.291789] systemd-journald[179]: Received request to flush runtime journal from PID 1
[    2.352938] [drm] Memory usable by graphics device = 2048M
[    2.352941] [drm] Replacing VGA console driver
[    2.353967] Console: switching to colour dummy device 80x25
[    2.377924] i915 0000:00:02.0: irq 30 for MSI/MSI-X
[    2.377943] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.377944] [drm] Driver supports precise vblank timestamp query.
[    2.378038] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.422272] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.422349] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
[    2.422481] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    2.486001] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    2.488690] RPC: Registered named UNIX socket transport module.
[    2.488693] RPC: Registered udp transport module.
[    2.488694] RPC: Registered tcp transport module.
[    2.488694] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.498069] FS-Cache: Loaded
[    2.533818] FS-Cache: Netfs 'nfs' registered for caching
[    2.558158] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    2.560006] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.575050] fbcon: inteldrmfb (fb0) is primary device
[    2.782677] Switched to clocksource tsc
[    2.849910] [drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    2.849912] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[    2.955266] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2182, fw id: 1164733
[    2.955287] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    2.994242] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[    3.407902] Console: switching to colour frame buffer device 200x56
[    3.416111] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.416116] i915 0000:00:02.0: registered panic notifier
[    3.674968] random: nonblocking pool is initialized
[    7.076053] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    7.273265] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9

-- 
- Jeremiah Mahler
