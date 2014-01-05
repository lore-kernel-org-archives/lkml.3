Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaAEJrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 04:47:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:29009 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaAEJrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 04:47:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,606,1384329600"; 
   d="scan'208";a="453822714"
Date: Sun, 5 Jan 2014 17:46:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140105094639.GA7423@localhost>
References: <20140102053101.GA29352@localhost>
 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Muthu,

On Fri, Jan 03, 2014 at 11:51:31AM -0800, Muthu Kumar wrote:
> Looks like Kent missed the btrfs endio in the original commit. How
> about this patch:
> 
> ---------
> 
> In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
> bi_remaining is accounted for correctly.
> 
> Reported-by: fengguang.wu@intel.com
> Cc: Kent Overstreet <kmo@daterainc.com>
> CC: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> --------
> 
>  fs/btrfs/volumes.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f2130de..edfed52 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
>                 }
>                 kfree(bbio);
> 
> -               bio_endio(bio, err);
> +                /*
> +                 * Call endio_nodec on the restored bio so the bi_remaining is
> +                 * accounted for correctly
> +                 */
> +               bio_endio_nodec(bio, err);
>         } else if (!is_orig_bio) {
>                 bio_put(bio);
>         }
 
Interestingly, the BUG message disappeared but it blocks the test run.
In the end, the test watchdog reboots the machine with SysRq:

        2014-01-04 23:13:02 mount -t btrfs /dev/vda /fs/vda
        [   20.184264] btrfs: device fsid f0e06999-0518-47e0-a622-21b8749438be devid 1 transid 4 /dev/vda
        [   20.186552] btrfs: disk space caching is enabled
        [  131.360457] random: nonblocking pool is initialized
==>     [ 1465.069342] SysRq : Emergency Sync
==>     [ 1475.071055] SysRq : Resetting

Attached is the full dmesg for a good run (v3.13-rc7) and a bad run
(this patch).

Thanks,
Fengguang

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-v3.13-rc7"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7 (kbuild@xian) (gcc version 4.8.1 (D=
ebian 4.8.1-8) ) #1 SMP Sun Jan 5 09:10:56 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/cyclic_x=
fstests-generic-4HDD-btrfs-generic-mid-BASE.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-lkp/v3.13-rc7/vmlinuz-3.13.0-rc7 kconfig=3Dx86_64-lkp com=
mit=3Dv3.13-rc7 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/=
kernel/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/modules.cgz max_=
uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-gener=
ic-mid/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/0 initrd=3D/kern=
el-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp oops=
=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled=
 panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 cons=
ole=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce0000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/c=
yclic_xfstests-generic-4HDD-btrfs-generic-mid-BASE.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-lkp/v3.13-rc7/vmlinuz-3.13.0-rc7 kconfig=3Dx86_64-lk=
p commit=3Dv3.13-rc7 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_initr=
d=3D/kernel/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/modules.cgz=
 max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-=
generic-mid/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3838760K/4193904K available (10296K kernel code, 123=
4K rwdata, 4144K rodata, 1428K init, 1736K bss, 355144K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7 (kbuild@xian) (gcc version 4.8.1 (D=
ebian 4.8.1-8) ) #1 SMP Sun Jan 5 09:10:56 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/cyclic_x=
fstests-generic-4HDD-btrfs-generic-mid-BASE.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-lkp/v3.13-rc7/vmlinuz-3.13.0-rc7 kconfig=3Dx86_64-lkp com=
mit=3Dv3.13-rc7 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_initrd=3D/=
kernel/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/modules.cgz max_=
uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-gener=
ic-mid/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/0 initrd=3D/kern=
el-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp oops=
=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled=
 panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 cons=
ole=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce0000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-1/c=
yclic_xfstests-generic-4HDD-btrfs-generic-mid-BASE.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-lkp/v3.13-rc7/vmlinuz-3.13.0-rc7 kconfig=3Dx86_64-lk=
p commit=3Dv3.13-rc7 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_initr=
d=3D/kernel/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/modules.cgz=
 max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-=
generic-mid/x86_64-lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-1::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3838760K/4193904K available (10296K kernel code, 123=
4K rwdata, 4144K rodata, 1428K init, 1736K bss, 355144K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D10774112)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.010744] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.013358] Mount-cache hash table entries: 256
[    0.014438] Initializing cgroup subsys memory
[    0.015237] Initializing cgroup subsys devices
[    0.016006] Initializing cgroup subsys freezer
[    0.016798] Initializing cgroup subsys blkio
[    0.017581] Initializing cgroup subsys perf_event
[    0.018407] Initializing cgroup subsys hugetlb
[    0.019261] mce: CPU supports 10 MCE banks
[    0.020042] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020042] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020042] tlb_flushall_shift: 6
[    0.022432] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - fff=
fffff824a6000)
[    0.028061] ACPI: Core revision 20131115
[    0.029464] ACPI: All ACPI Tables successfully acquired
[    0.030481] ftrace: allocating 39656 entries in 155 pages
[    0.040131] Getting VERSION: 50014
[    0.040832] Getting VERSION: 50014
[    0.044008] Getting ID: 0
[    0.044638] Getting ID: ff000000
[    0.045322] Getting LVT0: 8700
[    0.045992] Getting LVT1: 8400
[    0.046696] enabled ExtINT on CPU#0
[    0.048623] ENABLING IO-APIC IRQs
[    0.049312] init IO_APIC IRQs
[    0.049965]  apic 0 pin 0 not connected
[    0.050696] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052016] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053452] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.054899] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.056014] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.057427] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.058833] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060014] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.061440] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.062861] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.064014] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.065450] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068014] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.069436] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.070866] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.072013]  apic 0 pin 16 not connected
[    0.072745]  apic 0 pin 17 not connected
[    0.073467]  apic 0 pin 18 not connected
[    0.074193]  apic 0 pin 19 not connected
[    0.074921]  apic 0 pin 20 not connected
[    0.076002]  apic 0 pin 21 not connected
[    0.076732]  apic 0 pin 22 not connected
[    0.077463]  apic 0 pin 23 not connected
[    0.078327] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.079362] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.081347] Using local APIC timer interrupts.
[    0.081347] calibrating APIC timer ...
[    0.084000] ... lapic delta =3D 6249911
[    0.084000] ... PM-Timer delta =3D 357943
[    0.084000] ... PM-Timer result ok
[    0.084000] ..... delta 6249911
[    0.084000] ..... mult: 268431633
[    0.084000] ..... calibration result: 3999943
[    0.084000] ..... CPU clock speed is 2693.2108 MHz.
[    0.084000] ..... host bus clock speed is 999.3943 MHz.
[    0.084042] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.087351] x86: Booting SMP configuration:
[    0.088003] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 1:1ffef041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.104017] KVM setup async PF for cpu 1
 #2
[    0.105391] kvm-stealtime: cpu 1, msr 11fc8d040
[    0.008000] kvm-clock: cpu 2, msr 1:1ffef081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.116016] KVM setup async PF for cpu 2
 #3
[    0.117067] kvm-stealtime: cpu 2, msr 11fd0d040
[    0.008000] kvm-clock: cpu 3, msr 1:1ffef0c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.132028] x86: Booted up 1 node, 4 CPUs
[    0.132016] KVM setup async PF for cpu 3
[    0.132017] kvm-stealtime: cpu 3, msr 11fd8d040
[    0.136002] smpboot: Total of 4 processors activated (21548.22 BogoMIPS)
[    0.140152] devtmpfs: initialized
[    0.144875] xor: measuring software checksum speed
[    0.184011]    prefetch64-sse:   191.000 MB/sec
[    0.224012]    generic_sse:   188.000 MB/sec
[    0.224777] xor: using function: prefetch64-sse (191.000 MB/sec)
[    0.225710] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.226745] NET: Registered protocol family 16
[    0.228194] cpuidle: using governor ladder
[    0.228828] cpuidle: using governor menu
[    0.229999] ACPI: bus type PCI registered
[    0.232008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.233035] PCI: Using configuration type 1 for base access
[    0.264104] bio: create slab <bio-0> at 0
[    0.328027] raid6: sse2x1    8874 MB/s
[    0.396029] raid6: sse2x2   11313 MB/s
[    0.464022] raid6: sse2x4   12182 MB/s
[    0.464872] raid6: using algorithm sse2x4 (12182 MB/s)
[    0.465872] raid6: using intx1 recovery algorithm
[    0.468007] ACPI: Added _OSI(Module Device)
[    0.468007] ACPI: Added _OSI(Processor Device)
[    0.472013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.472954] ACPI: Added _OSI(Processor Aggregator Device)
[    0.472954] ACPI: Interpreter enabled
[    0.473266] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[    0.475162] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[    0.480654] ACPI: (supports S0 S3 S4 S5)
[    0.481489] ACPI: Using IOAPIC for interrupt routing
[    0.482455] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.484282] ACPI: No dock devices found.
[    0.492111] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.493132] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.494219] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.496099] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.498017] acpiphp: Slot [3] registered
[    0.498017] acpiphp: Slot [4] registered
[    0.500035] acpiphp: Slot [5] registered
[    0.500826] acpiphp: Slot [6] registered
[    0.500827] acpiphp: Slot [7] registered
[    0.500827] acpiphp: Slot [8] registered
[    0.500873] acpiphp: Slot [9] registered
[    0.504038] acpiphp: Slot [10] registered
[    0.504835] acpiphp: Slot [11] registered
[    0.504837] acpiphp: Slot [12] registered
[    0.504837] acpiphp: Slot [13] registered
[    0.508039] acpiphp: Slot [14] registered
[    0.508835] acpiphp: Slot [15] registered
[    0.508835] acpiphp: Slot [16] registered
[    0.508836] acpiphp: Slot [17] registered
[    0.508864] acpiphp: Slot [18] registered
[    0.512017] acpiphp: Slot [19] registered
[    0.512834] acpiphp: Slot [20] registered
[    0.512836] acpiphp: Slot [21] registered
[    0.512837] acpiphp: Slot [22] registered
[    0.516047] acpiphp: Slot [23] registered
[    0.516834] acpiphp: Slot [24] registered
[    0.516836] acpiphp: Slot [25] registered
[    0.516838] acpiphp: Slot [26] registered
[    0.520046] acpiphp: Slot [27] registered
[    0.520838] acpiphp: Slot [28] registered
[    0.520838] acpiphp: Slot [29] registered
[    0.520838] acpiphp: Slot [30] registered
[    0.520856] acpiphp: Slot [31] registered
[    0.524012] PCI host bridge to bus 0000:00
[    0.524816] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.525768] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.526798] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.528004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.529097] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.530213] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.531512] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.532380] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.537231] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.539283] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.540292] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.541740] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.542993] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.548592] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.553177] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.560550] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.561965] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.564492] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.566394] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.576900] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.578069] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.578069] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.578313] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.588065] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.589978] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.592004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.597581] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.597966] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.600902] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.607432] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.608940] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.610771] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.617126] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.618004] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.620910] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.626931] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.628943] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.630771] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.636693] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.637510] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.642466] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.644552] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.645877] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.647202] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.648518] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.649856] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.649856] ACPI: \_SB_.PCI0: notify handler is installed
[    0.652017] Found 1 acpi root devices
[    0.652817] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.653570] vgaarb: loaded
[    0.654271] vgaarb: bridge control possible 0000:00:02.0
[    0.656140] SCSI subsystem initialized
[    0.656853] libata version 3.00 loaded.
[    0.656853] ACPI: bus type USB registered
[    0.660053] usbcore: registered new interface driver usbfs
[    0.660996] usbcore: registered new interface driver hub
[    0.660996] usbcore: registered new device driver usb
[    0.664033] pps_core: LinuxPPS API ver. 1 registered
[    0.664900] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.666535] PTP clock support registered
[    0.668122] EDAC MC: Ver: 3.0.0
[    0.668177] PCI: Using ACPI for IRQ routing
[    0.668824] PCI: pci_cache_line_size set to 64 bytes
[    0.669861] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.670910] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.672508] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.673619] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.676014] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.680130] Switched to clocksource kvm-clock
[    0.692581] pnp: PnP ACPI init
[    0.693307] ACPI: bus type PNP registered
[    0.694120] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.695758] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.696875] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.698500] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.699570] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.701214] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.702322] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.703842] pnp 00:03: [dma 2]
[    0.704647] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.705731] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.707344] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.708441] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.710049] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.711282] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.712459] pnp: PnP ACPI: found 7 devices
[    0.713253] ACPI: bus type PNP unregistered
[    0.726666] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.727612] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.728565] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.729576] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.730641] NET: Registered protocol family 2
[    0.731660] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    0.733330] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.734703] TCP: Hash tables configured (established 32768 bind 32768)
[    0.735831] TCP: reno registered
[    0.736605] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.737645] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.738817] NET: Registered protocol family 1
[    0.739926] RPC: Registered named UNIX socket transport module.
[    0.740989] RPC: Registered udp transport module.
[    0.741841] RPC: Registered tcp transport module.
[    0.742693] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.743726] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.744734] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.745698] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.746716] pci 0000:00:02.0: Boot video device
[    0.747610] PCI: CLS 0 bytes, default 64
[    0.748467] Trying to unpack rootfs image as initramfs...
[    4.293284] Freeing initrd memory: 199808K (ffff880073ce0000 - ffff88008=
0000000)
[    4.294711] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.295685] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    4.297752] kvm: no hardware support
[    4.299177] Scanning for low memory corruption every 60 seconds
[    4.300759] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.302382] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    4.304256] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.308065] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.309098] PCLMULQDQ-NI instructions are not detected.
[    4.310040] AVX or AES-NI instructions are not detected.
[    4.310974] AVX instructions are not detected.
[    4.311845] AVX instructions are not detected.
[    4.312710] AVX instructions are not detected.
[    4.313566] AVX instructions are not detected.
[    4.338228] bounce pool size: 64 pages
[    4.339020] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.347641] VFS: Disk quotas dquot_6.5.2
[    4.348607] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.352035] NFS: Registering the id_resolver key type
[    4.352966] Key type id_resolver registered
[    4.353789] Key type id_legacy registered
[    4.354623] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.355712] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.357634] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.358706] fuse init (API version 7.22)
[    4.360018] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    4.364445] bio: create slab <bio-1> at 1
[    4.365951] Btrfs loaded
[    4.366629] msgmni has been set to 7887
[    4.373192] NET: Registered protocol family 38
[    4.374105] Key type asymmetric registered
[    4.375172] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.376872] io scheduler noop registered
[    4.377723] io scheduler deadline registered
[    4.378611] io scheduler cfq registered (default)
[    4.380036] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.381332] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.382715] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.384309] ACPI: Power Button [PWRF]
[    4.385494] GHES: HEST is not enabled!
[    4.386828] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.387897] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    4.391221] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.392306] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    4.395613] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.398532] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.406710] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.429032] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.431660] Non-volatile memory driver v1.3
[    4.435195] brd: module loaded
[    4.437334] loop: module loaded
[    4.438231] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.439208] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.440307] blk-mq: CPU -> queue map
[    4.441042]   CPU 0 -> Queue 0
[    4.441752]   CPU 1 -> Queue 0
[    4.442494]   CPU 2 -> Queue 0
[    4.443173]   CPU 3 -> Queue 0
[    4.444541]  vda: unknown partition table
[    4.447182] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.448210] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.449335] blk-mq: CPU -> queue map
[    4.450075]   CPU 0 -> Queue 0
[    4.450765]   CPU 1 -> Queue 0
[    4.451459]   CPU 2 -> Queue 0
[    4.452220]   CPU 3 -> Queue 0
[    4.453900]  vdb: unknown partition table
[    4.456435] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.457402] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.463848] blk-mq: CPU -> queue map
[    4.464616]   CPU 0 -> Queue 0
[    4.465327]   CPU 1 -> Queue 0
[    4.466002]   CPU 2 -> Queue 0
[    4.466680]   CPU 3 -> Queue 0
[    4.468395]  vdc: unknown partition table
[    4.470553] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.471508] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.472586] blk-mq: CPU -> queue map
[    4.473334]   CPU 0 -> Queue 0
[    4.474019]   CPU 1 -> Queue 0
[    4.474703]   CPU 2 -> Queue 0
[    4.475390]   CPU 3 -> Queue 0
[    4.476682]  vdd: unknown partition table
[    4.478956] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.479920] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    4.481007] blk-mq: CPU -> queue map
[    4.481756]   CPU 0 -> Queue 0
[    4.482442]   CPU 1 -> Queue 0
[    4.483131]   CPU 2 -> Queue 0
[    4.483819]   CPU 3 -> Queue 0
[    4.485373]  vde: unknown partition table
[    4.487768] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    4.488780] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    4.489831] blk-mq: CPU -> queue map
[    4.490571]   CPU 0 -> Queue 0
[    4.491253]   CPU 1 -> Queue 0
[    4.491961]   CPU 2 -> Queue 0
[    4.492687]   CPU 3 -> Queue 0
[    4.494193]  vdf: unknown partition table
[    4.496373] lkdtm: No crash points registered, enable through debugfs
[    4.498204] Loading iSCSI transport class v2.0-870.
[    4.500268] Adaptec aacraid driver 1.2-0[30200]-ms
[    4.501237] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.502527] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    4.504271] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.505820] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.507005] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    4.508325] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.509416] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.510776] ata_piix 0000:00:01.1: version 2.13
[    4.513820] scsi0 : ata_piix
[    4.514695] scsi1 : ata_piix
[    4.515529] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    4.516636] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    4.519621] tun: Universal TUN/TAP device driver, 1.6
[    4.520598] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.522488] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    4.523801] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.524793] Copyright (c) 2007 Atheros Corporation.
[    4.526165] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    4.527347] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    4.527347]   http://www.scyld.com/network/drivers.html
[    4.529636] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    4.530903] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.531905] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.532946] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    4.534039] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.672440] ata2.01: NODEV after polling detection
[    4.673573] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    4.674894] ata2.00: configured for MWDMA2
[    4.676383] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    4.678532] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[    4.856485] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    4.857535] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.858785] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.859711] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.860886] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    4.861923] igb: Copyright (c) 2007-2013 Intel Corporation.
[    4.863005] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    4.864426] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    4.865569] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    4.866625] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.867972] sky2: driver version 1.30
[    4.870323] usbcore: registered new interface driver catc
[    4.871330] usbcore: registered new interface driver kaweth
[    4.872290] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    4.873773] usbcore: registered new interface driver pegasus
[    4.874810] usbcore: registered new interface driver rtl8150
[    4.875836] usbcore: registered new interface driver asix
[    4.876871] usbcore: registered new interface driver ax88179_178a
[    4.877932] usbcore: registered new interface driver cdc_ether
[    4.878962] usbcore: registered new interface driver r815x
[    4.879979] usbcore: registered new interface driver cdc_eem
[    4.881021] usbcore: registered new interface driver dm9601
[    4.882029] usbcore: registered new interface driver smsc75xx
[    4.883087] usbcore: registered new interface driver smsc95xx
[    4.884117] usbcore: registered new interface driver gl620a
[    4.885143] usbcore: registered new interface driver net1080
[    4.886162] usbcore: registered new interface driver plusb
[    4.887191] usbcore: registered new interface driver rndis_host
[    4.888249] usbcore: registered new interface driver cdc_subset
[    4.889287] usbcore: registered new interface driver zaurus
[    4.890319] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    4.891801] usbcore: registered new interface driver int51x1
[    4.892867] usbcore: registered new interface driver ipheth
[    4.893881] usbcore: registered new interface driver sierra_net
[    4.894928] usbcore: registered new interface driver cdc_ncm
[    4.895885] Fusion MPT base driver 3.04.20
[    4.896665] Copyright (c) 1999-2008 LSI Corporation
[    4.897521] Fusion MPT SPI Host driver 3.04.20
[    4.898444] Fusion MPT FC Host driver 3.04.20
[    4.899337] Fusion MPT SAS Host driver 3.04.20
[    4.900258] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.901325] mptctl: Registered with Fusion MPT base driver
[    4.902239] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    4.903432] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.904534] ehci-pci: EHCI PCI platform driver
[    4.905494] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.906538] ohci-pci: OHCI PCI platform driver
[    4.907494] uhci_hcd: USB Universal Host Controller Interface driver
[    4.908797] usbcore: registered new interface driver usb-storage
[    4.909884] usbcore: registered new interface driver ums-alauda
[    4.910992] usbcore: registered new interface driver ums-datafab
[    4.912089] usbcore: registered new interface driver ums-freecom
[    4.913202] usbcore: registered new interface driver ums-isd200
[    4.914316] usbcore: registered new interface driver ums-jumpshot
[    4.915414] usbcore: registered new interface driver ums-sddr09
[    4.916521] usbcore: registered new interface driver ums-sddr55
[    4.917636] usbcore: registered new interface driver ums-usbat
[    4.918710] usbcore: registered new interface driver usbtest
[    4.919860] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.922213] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.923188] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.924620] mousedev: PS/2 mouse device common for all mice
[    4.926660] rtc_cmos 00:00: RTC can wake from S4
[    4.927583] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.930029] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.931255] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.932903] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.934288] i6300esb: initialized (0xffffc90000718000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    4.936141] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.937394] iTCO_vendor_support: vendor-support=3D0
[    4.938359] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.939961] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.941719] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    4.943676] md: linear personality registered for level -1
[    4.944679] md: raid0 personality registered for level 0
[    4.945667] md: raid1 personality registered for level 1
[    4.946615] md: raid10 personality registered for level 10
[    4.948085] md: raid6 personality registered for level 6
[    4.949126] md: raid5 personality registered for level 5
[    4.950231] md: raid4 personality registered for level 4
[    4.951237] md: multipath personality registered for level -4
[    4.952326] md: faulty personality registered for level -5
[    4.954319] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    4.956583] device-mapper: multipath: version 1.6.0 loaded
[    4.957630] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.958826] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    4.959930] device-mapper: cache cleaner: version 1.0.0 loaded
[    4.961735] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    4.966240] usbcore: registered new interface driver usbhid
[    4.967288] usbhid: USB HID core driver
[    4.968366] TCP: bic registered
[    4.969140] Initializing XFRM netlink socket
[    4.970451] NET: Registered protocol family 10
[    4.971589] sit: IPv6 over IPv4 tunneling driver
[    4.972900] NET: Registered protocol family 17
[    4.973852] 8021q: 802.1Q VLAN Support v1.8
[    4.974984] sctp: Hash tables configured (established 65536 bind 65536)
[    4.976430] Key type dns_resolver registered
[    4.978356]=20
[    4.978356] printing PIC contents
[    4.979652] ... PIC  IMR: ffff
[    4.980418] ... PIC  IRR: 9113
[    4.981194] ... PIC  ISR: 0000
[    4.987730] ... PIC ELCR: 0c00
[    4.988560] printing local APIC contents on CPU#0/0:
[    4.989493] ... APIC ID:      00000000 (0)
[    4.990316] ... APIC VERSION: 00050014
[    4.991097] ... APIC TASKPRI: 00000000 (00)
[    4.991924] ... APIC PROCPRI: 00000000
[    4.992548] ... APIC LDR: 01000000
[    4.992548] ... APIC DFR: ffffffff
[    4.992548] ... APIC SPIV: 000001ff
[    4.992548] ... APIC ISR field:
[    4.992548] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.992548] ... APIC TMR field:
[    4.992548] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.992548] ... APIC IRR field:
[    4.992548] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.992548] ... APIC ESR: 00000000
[    4.992548] ... APIC ICR: 000008fd
[    4.992548] ... APIC ICR2: 08000000
[    4.992548] ... APIC LVTT: 000000ef
[    4.992548] ... APIC LVTPC: 00010000
[    4.992548] ... APIC LVT0: 00010700
[    4.992548] ... APIC LVT1: 00000400
[    4.992548] ... APIC LVTERR: 000000fe
[    4.992548] ... APIC TMICT: 7fffffff
[    4.992548] ... APIC TMCCT: 7fcebc7c
[    4.992548] ... APIC TDCR: 00000003
[    4.992548]=20
[    5.010240] number of MP IRQ sources: 15.
[    5.011051] number of IO-APIC #0 registers: 24.
[    5.011904] testing the IO APIC.......................
[    5.012856] IO APIC #0......
[    5.013528] .... register #00: 00000000
[    5.014323] .......    : physical APIC id: 00
[    5.015148] .......    : Delivery Type: 0
[    5.015926] .......    : LTS          : 0
[    5.016766] .... register #01: 00170011
[    5.017533] .......     : max redirection entries: 17
[    5.018423] .......     : PRQ implemented: 0
[    5.019263] .......     : IO APIC version: 11
[    5.020115] .... register #02: 00000000
[    5.020875] .......     : arbitration: 00
[    5.021659] .... IRQ redirection table:
[    5.022455] 1    0    0   0   0    0    0    00
[    5.023301] 0    0    0   0   0    1    1    31
[    5.024179] 0    0    0   0   0    1    1    30
[    5.025047] 0    0    0   0   0    1    1    33
[    5.025886] 1    0    0   0   0    1    1    34
[    5.026727] 1    1    0   0   0    1    1    35
[    5.027609] 0    0    0   0   0    1    1    36
[    5.028486] 0    0    0   0   0    1    1    37
[    5.029332] 0    0    0   0   0    1    1    38
[    5.030195] 0    1    0   0   0    1    1    39
[    5.031036] 1    1    0   0   0    1    1    3A
[    5.031878] 1    1    0   0   0    1    1    3B
[    5.032785] 0    0    0   0   0    1    1    3C
[    5.033626] 0    0    0   0   0    1    1    3D
[    5.034474] 0    0    0   0   0    1    1    3E
[    5.035340] 0    0    0   0   0    1    1    3F
[    5.036220] 1    0    0   0   0    0    0    00
[    5.037059] 1    0    0   0   0    0    0    00
[    5.037928] 1    0    0   0   0    0    0    00
[    5.038777] 1    0    0   0   0    0    0    00
[    5.039619] 1    0    0   0   0    0    0    00
[    5.040517] 1    0    0   0   0    0    0    00
[    5.041359] 1    0    0   0   0    0    0    00
[    5.042208] 1    0    0   0   0    0    0    00
[    5.043068] IRQ to pin mappings:
[    5.043769] IRQ0 -> 0:2
[    5.044564] IRQ1 -> 0:1
[    5.045322] IRQ3 -> 0:3
[    5.046106] IRQ4 -> 0:4
[    5.046857] IRQ5 -> 0:5
[    5.047613] IRQ6 -> 0:6
[    5.048416] IRQ7 -> 0:7
[    5.049187] IRQ8 -> 0:8
[    5.049941] IRQ9 -> 0:9
[    5.050701] IRQ10 -> 0:10
[    5.051504] IRQ11 -> 0:11
[    5.052342] IRQ12 -> 0:12
[    5.053116] IRQ13 -> 0:13
[    5.053915] IRQ14 -> 0:14
[    5.054689] IRQ15 -> 0:15
[    5.055461] .................................... done.
[    5.056978] registered taskstats version 1
[    5.059308] rtc_cmos 00:00: setting system clock to 2014-01-05 09:26:00 =
UTC (1388913960)
[    5.060876] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    5.066143] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.067156] 8021q: adding VLAN 0 to HW filter on device eth0
[    5.296114] tsc: Refined TSC clocksource calibration: 2693.406 MHz
[    5.550628] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.072519] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    7.076094] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.092086] Sending DHCP requests ., OK
[    7.148079] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    7.149313] IP-Config: Complete:
[    7.150026]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.151684]      host=3Dvpx-1, domain=3D, nis-domain=3D(none)
[    7.152615]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    7.153308]      nameserver0=3D10.0.2.3
[    7.154544] PM: Hibernation image not present or could not be loaded.
[    7.156876] Freeing unused kernel memory: 1428K (ffffffff82336000 - ffff=
ffff8249b000)
[    7.158372] Write protecting the kernel read-only data: 18432k
[    7.163505] Freeing unused kernel memory: 1980K (ffff880001a11000 - ffff=
880001c00000)
[    7.168754] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff=
880002200000)
[    7.360812] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.362333] platform microcode: Direct firmware load failed with error -2
[    7.363591] platform microcode: Falling back to user helper
[    7.383760] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.384792] platform microcode: Direct firmware load failed with error -2
[    7.385903] platform microcode: Falling back to user helper
[    7.390784] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.391835] platform microcode: Direct firmware load failed with error -2
[    7.393044] platform microcode: Falling back to user helper
[    7.396361] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.397768] platform microcode: Direct firmware load failed with error -2
[    7.398988] platform microcode: Falling back to user helper
[    7.403098] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    7.676804] random: vgscan urandom read with 20 bits of entropy available

=3D=3D> /tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /tmp/err_log <=3D=3D

=3D=3D> /tmp/run_log <=3D=3D
downloading latest lkp src code
Files /etc/init.d/nfsroot and /lkp/lkp/src/rootfs/addon/etc/init.d/nfsroot =
differ
find a new version of this script, reloading...
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-generic-mid/x86_64-=
lkp/d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc/0
job=3D/lkp/scheduled/vpx-1/cyclic_xfstests-generic-4HDD-btrfs-generic-mid-B=
ASE.yaml
2014-01-05 09:26:16 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/vpx-1/cyclic_xfstests-generic-4HDD-btrfs-generic-mid=
-BASE.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/fs
2014-01-05 09:26:17 mkfs -t btrfs /dev/vda
2014-01-05 09:26:17 mkfs -t btrfs /dev/vdd
2014-01-05 09:26:17 mkfs -t btrfs /dev/vdb
run: /lkp/lkp/src/monitors/event/wait pre-test
2014-01-05 09:26:17 mkfs -t btrfs /dev/vdc
[   21.686194] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f=20
WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vda

esize 4096 leafsize 4096 sectorsize 4096 size 256.00GiB
Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdb

Btrfs v0.20-rc1-566-gd1570a0
[   21.694366] btrfs: device fsid f41fed20-4953-4ef6-8439-6af23ea770ce devi=
d 1 transid 4 /dev/vdb

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdc

Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdd

Btrfs v0.20-rc1-566-gd1570a0
[   21.706065] btrfs: device fsid ab106b1e-c999-4ee0-bdfe-4166e7abf960 devi=
d 1 transid 4 /dev/vdd
2014-01-05 09:26:17 mount -t btrfs /dev/vda /fs/vda
[   21.711922] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 4 /dev/vda
[   21.714361] btrfs: disk space caching is enabled
[   21.717375] btrfs: creating UUID tree
[   21.717998] btrfs: device fsid 4d3522e8-090a-4693-928f-fd5e119421d9 devi=
d 1 transid 4 /dev/vdc
2014-01-05 09:26:17 mount -t btrfs /dev/vdb /fs/vdb
[   21.727470] btrfs: device fsid f41fed20-4953-4ef6-8439-6af23ea770ce devi=
d 1 transid 4 /dev/vdb
[   21.729495] btrfs: device fsid 4d3522e8-090a-4693-928f-fd5e119421d9 devi=
d 1 transid 4 /dev/vdc
[   21.730255] btrfs: disk space caching is enabled
[   21.738193] btrfs: creating UUID tree
2014-01-05 09:26:17 mount -t btrfs /dev/vdc /fs/vdc
[   21.746607] btrfs: device fsid 4d3522e8-090a-4693-928f-fd5e119421d9 devi=
d 1 transid 4 /dev/vdc
[   21.748439] btrfs: device fsid 4d3522e8-090a-4693-928f-fd5e119421d9 devi=
d 1 transid 4 /dev/vdc
[   21.750561] btrfs: disk space caching is enabled
[   21.753346] btrfs: creating UUID tree
2014-01-05 09:26:17 mount -t btrfs /dev/vdd /fs/vdd
[   21.760852] btrfs: device fsid ab106b1e-c999-4ee0-bdfe-4166e7abf960 devi=
d 1 transid 4 /dev/vdd
[   21.762957] btrfs: disk space caching is enabled
[   21.765694] btrfs: creating UUID tree
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /lkp/lkp/src/monitors/wrapper pmeter
run: /lkp/lkp/src/monitors/wrapper diskstats
run: /lkp/lkp/src/monitors/wrapper zoneinfo
run: /lkp/lkp/src/monitors/wrapper energy
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/micro/wrapper xfstests
[   23.360688] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 6 /dev/vda
[   23.362741] btrfs: disk space caching is enabled
[   23.392041] btrfs: device fsid 4c689df9-5dd5-4ef8-84cb-22370e82b91b devi=
d 1 transid 4 /dev/vdb
[   23.394912] btrfs: device fsid 4c689df9-5dd5-4ef8-84cb-22370e82b91b devi=
d 1 transid 4 /dev/vdb
[   23.397328] btrfs: disk space caching is enabled
[   23.400171] btrfs: creating UUID tree
[   23.525266] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 7 /dev/vda
[   23.527317] btrfs: disk space caching is enabled
[   23.792756] btrfs: device fsid b2a1ed94-e50c-48d7-9617-78427c750d10 devi=
d 1 transid 4 /dev/vdb
[   23.796430] btrfs: device fsid b2a1ed94-e50c-48d7-9617-78427c750d10 devi=
d 1 transid 4 /dev/vdb
[   23.798558] btrfs: disk space caching is enabled
[   23.801666] btrfs: creating UUID tree
[   30.614554] random: nonblocking pool is initialized
[   65.126943] btrfs: device fsid b2a1ed94-e50c-48d7-9617-78427c750d10 devi=
d 1 transid 1209 /dev/vdb
[   65.129411] btrfs: disk space caching is enabled
[   65.269246] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 8 /dev/vda
[   65.271338] btrfs: disk space caching is enabled
[   74.153530] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 10 /dev/vda
[   74.156173] btrfs: disk space caching is enabled
[   74.346269] btrfs: device fsid 460c811f-f73c-46bc-981f-3a176b693ad5 devi=
d 1 transid 4 /dev/vdb
[   74.348919] btrfs: disk space caching is enabled
[   74.352067] btrfs: creating UUID tree
[   74.352191] btrfs: device fsid 460c811f-f73c-46bc-981f-3a176b693ad5 devi=
d 1 transid 4 /dev/vdb
[   74.735070] btrfs: device fsid 460c811f-f73c-46bc-981f-3a176b693ad5 devi=
d 1 transid 74 /dev/vdb
[   74.737258] btrfs: disk space caching is enabled
[   74.870463] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 12 /dev/vda
[   74.873019] btrfs: disk space caching is enabled
[   75.143678] btrfs: device fsid 01d89823-9eb0-4ecb-b87a-eeac4cff75f3 devi=
d 1 transid 4 /dev/vdb
[   75.147769] btrfs: device fsid 01d89823-9eb0-4ecb-b87a-eeac4cff75f3 devi=
d 1 transid 4 /dev/vdb
[   75.150093] btrfs: disk space caching is enabled
[   75.152969] btrfs: creating UUID tree
[   90.488275] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 13 /dev/vda
[   90.490686] btrfs: disk space caching is enabled
[  151.813424] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 15 /dev/vda
[  151.815935] btrfs: disk space caching is enabled
[  151.990786] btrfs: device fsid 55aef784-8102-4c2f-ab3d-b70dbd111e10 devi=
d 1 transid 4 /dev/vdb
[  151.993293] btrfs: disk space caching is enabled
[  151.996145] btrfs: creating UUID tree
[  151.997073] btrfs: device fsid 55aef784-8102-4c2f-ab3d-b70dbd111e10 devi=
d 1 transid 4 /dev/vdb
[  154.293894] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 16 /dev/vda
[  154.296857] btrfs: disk space caching is enabled
[  194.577117] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 19 /dev/vda
[  194.579787] btrfs: disk space caching is enabled
[  194.757505] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 20 /dev/vda
[  194.759990] btrfs: disk space caching is enabled
[  226.198990] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 22 /dev/vda
[  226.201647] btrfs: disk space caching is enabled
[  226.655656] btrfs: device fsid 85e46346-5d87-448a-b6e6-6a24292989cd devi=
d 1 transid 4 /dev/vdb
[  226.657950] btrfs: device fsid 85e46346-5d87-448a-b6e6-6a24292989cd devi=
d 1 transid 4 /dev/vdb
[  226.660123] btrfs: disk space caching is enabled
[  226.662287] btrfs: creating UUID tree
[  227.654139] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 24 /dev/vda
[  227.656813] btrfs: disk space caching is enabled
[  227.980655] btrfs: device fsid edab87ae-4eca-4e38-813e-88ef7b5085a5 devi=
d 1 transid 4 /dev/vdb
[  227.984061] btrfs: device fsid edab87ae-4eca-4e38-813e-88ef7b5085a5 devi=
d 1 transid 4 /dev/vdb
[  227.986086] btrfs: disk space caching is enabled
[  227.988839] btrfs: creating UUID tree
[  228.641701] btrfs: device fsid edab87ae-4eca-4e38-813e-88ef7b5085a5 devi=
d 1 transid 7 /dev/vdb
[  228.644372] btrfs: disk space caching is enabled
[  230.470335] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 25 /dev/vda
[  230.472722] btrfs: disk space caching is enabled
[  303.193594] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 29 /dev/vda
[  303.196208] btrfs: disk space caching is enabled
[  306.599210] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 32 /dev/vda
[  306.601919] btrfs: disk space caching is enabled
[  306.793201] btrfs: device fsid 33c1f8de-3092-43d7-ae2e-41c65957d145 devi=
d 1 transid 4 /dev/vdb
[  306.797565] btrfs: device fsid 33c1f8de-3092-43d7-ae2e-41c65957d145 devi=
d 1 transid 4 /dev/vdb
[  306.799717] btrfs: disk space caching is enabled
[  306.802196] btrfs: creating UUID tree
[  321.752146] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 34 /dev/vda
[  321.754368] btrfs: disk space caching is enabled
[  322.287181] btrfs: device fsid 4581f54b-4cb0-4eec-b37d-83a152038145 devi=
d 1 transid 4 /dev/vdb
[  322.290669] btrfs: device fsid 4581f54b-4cb0-4eec-b37d-83a152038145 devi=
d 1 transid 4 /dev/vdb
[  322.293033] btrfs: disk space caching is enabled
[  322.295703] btrfs: creating UUID tree
[  324.583836] btrfs: device fsid 4b6dec9b-3a1d-4a21-b40a-c3160e92023f devi=
d 1 transid 35 /dev/vda
[  324.586444] btrfs: disk space caching is enabled
[  341.476305] Unregister pv shared memory for cpu 3
[  341.476307] Unregister pv shared memory for cpu 0
[  341.476310] Unregister pv shared memory for cpu 2
[  341.478969] Unregister pv shared memory for cpu 1
[  341.483396] reboot: Restarting system
[  341.484135] reboot: machine restart
Elapsed time: 360
numactl --preferred=3D0 --physcpubind=3D4-7 qemu-system-x86_64 -cpu kvm64 -=
enable-kvm -kernel /kernel/x86_64-lkp/v3.13-rc7/vmlinuz-3.13.0-rc7 -append =
'user=3Dlkp job=3D/lkp/scheduled/vpx-1/cyclic_xfstests-generic-4HDD-btrfs-g=
eneric-mid-BASE.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/v3.13-rc=
7/vmlinuz-3.13.0-rc7 kconfig=3Dx86_64-lkp commit=3Dv3.13-rc7 bm_initrd=3D/l=
kp/benchmarks/xfstests.cgz modules_initrd=3D/kernel/x86_64-lkp/d6e0a2dd12f4=
067a5bcefb8bbd8ddbeff800afbc/modules.cgz max_uptime=3D1269 RESULT_ROOT=3D/l=
kp/result/vpx/micro/xfstests/4HDD-btrfs-generic-mid/x86_64-lkp/d6e0a2dd12f4=
067a5bcefb8bbd8ddbeff800afbc/0 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz=
 root=3D/dev/ram0 ip=3D::::vpx-1::dhcp oops=3Dpanic earlyprintk=3DttyS0,115=
200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 pro=
mpt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal'  -initr=
d /fs/sdb1/initrd-vpx-1 -m 4G -smp 4 -net nic,vlan=3D1,model=3De1000 -net u=
ser,vlan=3D1,hostfwd=3Dtcp::9318-:22 -boot order=3Dnc -no-reboot -watchdog =
i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdb1/disk0-vpx-1,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sdb1/disk1-vpx-1,media=3Ddisk,if=3Dvirtio=
 -drive file=3D/fs/sdb1/disk2-vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sdb1/disk3-vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdb1/disk4-=
vpx-1,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdb1/disk5-vpx-1,media=3Dd=
isk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-1 -serial file:/dev/shm/kbo=
ot/serial-vpx-1 -daemonize -display none -monitor null=20

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-bio_endio_nodec
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-wl-02230-gc40bbf4 (kbuild@xian) (gc=
c version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Jan 4 23:03:13 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/cyclic_x=
fstests-generic-4HDD-btrfs-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/vmlinuz-3.13=
=2E0-rc6-wl-02230-gc40bbf4 kconfig=3Dx86_64-lkp commit=3Dc40bbf4184be2c0a2e=
e0740299e46721711518ff bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_ini=
trd=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/modules.c=
gz max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrf=
s-generic-mid/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/0 initrd=
=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-2::dhc=
p oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce0000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/c=
yclic_xfstests-generic-4HDD-btrfs-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/vmlinuz=
-3.13.0-rc6-wl-02230-gc40bbf4 kconfig=3Dx86_64-lkp commit=3Dc40bbf4184be2c0=
a2ee0740299e46721711518ff bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_=
initrd=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/module=
s.cgz max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-b=
trfs-generic-mid/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/0 init=
rd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-2::d=
hcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always=
_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115=
200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3838760K/4193904K available (10303K kernel code, 123=
4K rwdata, 4144K rodata, 1428K init, 1736K bss, 355144K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-wl-02230-gc40bbf4 (kbuild@xian) (gc=
c version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Jan 4 23:03:13 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/cyclic_x=
fstests-generic-4HDD-btrfs-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/vmlinuz-3.13=
=2E0-rc6-wl-02230-gc40bbf4 kconfig=3Dx86_64-lkp commit=3Dc40bbf4184be2c0a2e=
e0740299e46721711518ff bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_ini=
trd=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/modules.c=
gz max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrf=
s-generic-mid/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/0 initrd=
=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-2::dhc=
p oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73ce0000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1048476
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 11fc0d040
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-2/c=
yclic_xfstests-generic-4HDD-btrfs-generic-mid-HEAD.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/vmlinuz=
-3.13.0-rc6-wl-02230-gc40bbf4 kconfig=3Dx86_64-lkp commit=3Dc40bbf4184be2c0=
a2ee0740299e46721711518ff bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_=
initrd=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/module=
s.cgz max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-b=
trfs-generic-mid/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/0 init=
rd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-2::d=
hcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always=
_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115=
200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3838760K/4193904K available (10303K kernel code, 123=
4K rwdata, 4144K rodata, 1428K init, 1736K bss, 355144K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D10774112)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.011340] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.013519] Mount-cache hash table entries: 256
[    0.014698] Initializing cgroup subsys memory
[    0.016011] Initializing cgroup subsys devices
[    0.016877] Initializing cgroup subsys freezer
[    0.017750] Initializing cgroup subsys blkio
[    0.018600] Initializing cgroup subsys perf_event
[    0.019496] Initializing cgroup subsys hugetlb
[    0.020064] mce: CPU supports 10 MCE banks
[    0.020935] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020935] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020935] tlb_flushall_shift: 6
[    0.024079] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - fff=
fffff824a6000)
[    0.030242] ACPI: Core revision 20131115
[    0.031715] ACPI: All ACPI Tables successfully acquired
[    0.032440] ftrace: allocating 39666 entries in 155 pages
[    0.044144] Getting VERSION: 50014
[    0.048009] Getting VERSION: 50014
[    0.048836] Getting ID: 0
[    0.049582] Getting ID: ff000000
[    0.050399] Getting LVT0: 8700
[    0.051186] Getting LVT1: 8400
[    0.052061] enabled ExtINT on CPU#0
[    0.053609] ENABLING IO-APIC IRQs
[    0.054425] init IO_APIC IRQs
[    0.055197]  apic 0 pin 0 not connected
[    0.056008] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.057733] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060017] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.061739] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.063457] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.064015] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065721] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068016] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.069714] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072016] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.073735] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.075463] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.076015] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.077743] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.080016] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.081721]  apic 0 pin 16 not connected
[    0.082588]  apic 0 pin 17 not connected
[    0.084003]  apic 0 pin 18 not connected
[    0.084880]  apic 0 pin 19 not connected
[    0.085755]  apic 0 pin 20 not connected
[    0.086630]  apic 0 pin 21 not connected
[    0.087515]  apic 0 pin 22 not connected
[    0.088002]  apic 0 pin 23 not connected
[    0.088962] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.090162] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.092948] Using local APIC timer interrupts.
[    0.092948] calibrating APIC timer ...
[    0.096000] ... lapic delta =3D 6250295
[    0.096000] ... PM-Timer delta =3D 357991
[    0.096000] ... PM-Timer result ok
[    0.096000] ..... delta 6250295
[    0.096000] ..... mult: 268448126
[    0.096000] ..... calibration result: 4000188
[    0.096000] ..... CPU clock speed is 2693.2722 MHz.
[    0.096000] ..... host bus clock speed is 1000.0188 MHz.
[    0.096047] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.099681] x86: Booting SMP configuration:
[    0.100003] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 1:1ffef041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.116022] KVM setup async PF for cpu 1
 #2
[    0.117382] kvm-stealtime: cpu 1, msr 11fc8d040
[    0.008000] kvm-clock: cpu 2, msr 1:1ffef081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.132022] KVM setup async PF for cpu 2
 #3
[    0.133060] kvm-stealtime: cpu 2, msr 11fd0d040
[    0.008000] kvm-clock: cpu 3, msr 1:1ffef0c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.148032] x86: Booted up 1 node, 4 CPUs
[    0.148020] KVM setup async PF for cpu 3
[    0.148020] kvm-stealtime: cpu 3, msr 11fd8d040
[    0.150868] smpboot: Total of 4 processors activated (21548.22 BogoMIPS)
[    0.152438] devtmpfs: initialized
[    0.156994] xor: measuring software checksum speed
[    0.196033]    prefetch64-sse:   105.000 MB/sec
[    0.236031]    generic_sse:   104.000 MB/sec
[    0.236858] xor: using function: prefetch64-sse (105.000 MB/sec)
[    0.237885] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.239058] NET: Registered protocol family 16
[    0.240418] cpuidle: using governor ladder
[    0.240831] cpuidle: using governor menu
[    0.241970] ACPI: bus type PCI registered
[    0.242777] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.244058] PCI: Using configuration type 1 for base access
[    0.268028] bio: create slab <bio-0> at 0
[    0.336002] raid6: sse2x1    8852 MB/s
[    0.404005] raid6: sse2x2   11157 MB/s
[    0.472003] raid6: sse2x4   13038 MB/s
[    0.472800] raid6: using algorithm sse2x4 (13038 MB/s)
[    0.473713] raid6: using intx1 recovery algorithm
[    0.474641] ACPI: Added _OSI(Module Device)
[    0.475480] ACPI: Added _OSI(Processor Device)
[    0.476011] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.476907] ACPI: Added _OSI(Processor Aggregator Device)
[    0.479351] ACPI: Interpreter enabled
[    0.480007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[    0.481806] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[    0.484010] ACPI: (supports S0 S3 S4 S5)
[    0.484796] ACPI: Using IOAPIC for interrupt routing
[    0.485711] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.485919] ACPI: No dock devices found.
[    0.492163] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.496010] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.497149] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.498306] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.500248] acpiphp: Slot [3] registered
[    0.500828] acpiphp: Slot [4] registered
[    0.500835] acpiphp: Slot [5] registered
[    0.500835] acpiphp: Slot [6] registered
[    0.504051] acpiphp: Slot [7] registered
[    0.504849] acpiphp: Slot [8] registered
[    0.504849] acpiphp: Slot [9] registered
[    0.504849] acpiphp: Slot [10] registered
[    0.508037] acpiphp: Slot [11] registered
[    0.508887] acpiphp: Slot [12] registered
[    0.508887] acpiphp: Slot [13] registered
[    0.508887] acpiphp: Slot [14] registered
[    0.508887] acpiphp: Slot [15] registered
[    0.512114] acpiphp: Slot [16] registered
[    0.512848] acpiphp: Slot [17] registered
[    0.512848] acpiphp: Slot [18] registered
[    0.512848] acpiphp: Slot [19] registered
[    0.516033] acpiphp: Slot [20] registered
[    0.516884] acpiphp: Slot [21] registered
[    0.516884] acpiphp: Slot [22] registered
[    0.516884] acpiphp: Slot [23] registered
[    0.520040] acpiphp: Slot [24] registered
[    0.520905] acpiphp: Slot [25] registered
[    0.520905] acpiphp: Slot [26] registered
[    0.520905] acpiphp: Slot [27] registered
[    0.520905] acpiphp: Slot [28] registered
[    0.524086] acpiphp: Slot [29] registered
[    0.524860] acpiphp: Slot [30] registered
[    0.524860] acpiphp: Slot [31] registered
[    0.524860] PCI host bridge to bus 0000:00
[    0.528004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.529006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.530027] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.531047] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.532055] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.533229] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.534494] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.536298] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.539616] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.541088] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.541341] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.544013] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.545287] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.548593] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.552576] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.559455] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.560363] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.562280] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.564966] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.576003] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.577233] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.578032] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.580909] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.586954] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.588981] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.590833] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.596703] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.598020] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.600907] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.606506] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.608470] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.610330] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.616258] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.618031] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.620455] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.626046] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.628004] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.629875] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.636038] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.637546] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.641543] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.641821] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.644827] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.646179] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.647496] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.648840] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.649187] ACPI: \_SB_.PCI0: notify handler is installed
[    0.650132] Found 1 acpi root devices
[    0.652063] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.653544] vgaarb: loaded
[    0.654197] vgaarb: bridge control possible 0000:00:02.0
[    0.656016] SCSI subsystem initialized
[    0.656070] libata version 3.00 loaded.
[    0.656841] ACPI: bus type USB registered
[    0.656842] usbcore: registered new interface driver usbfs
[    0.660060] usbcore: registered new interface driver hub
[    0.660970] usbcore: registered new device driver usb
[    0.660970] pps_core: LinuxPPS API ver. 1 registered
[    0.660970] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.664026] PTP clock support registered
[    0.664822] EDAC MC: Ver: 3.0.0
[    0.664967] PCI: Using ACPI for IRQ routing
[    0.668006] PCI: pci_cache_line_size set to 64 bytes
[    0.669081] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.670076] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.672300] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.673462] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.674599] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.680098] Switched to clocksource kvm-clock
[    0.692810] pnp: PnP ACPI init
[    0.693539] ACPI: bus type PNP registered
[    0.694373] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.696030] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.697120] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.698803] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.699885] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.701593] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.702692] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.704245] pnp 00:03: [dma 2]
[    0.705076] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.706184] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.707837] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.708957] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.710606] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.712059] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.713199] pnp: PnP ACPI: found 7 devices
[    0.713999] ACPI: bus type PNP unregistered
[    0.729142] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.730127] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.731100] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.732159] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.733262] NET: Registered protocol family 2
[    0.734309] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    0.735930] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.737367] TCP: Hash tables configured (established 32768 bind 32768)
[    0.738560] TCP: reno registered
[    0.739303] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.740393] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.741564] NET: Registered protocol family 1
[    0.742635] RPC: Registered named UNIX socket transport module.
[    0.743624] RPC: Registered udp transport module.
[    0.744496] RPC: Registered tcp transport module.
[    0.745358] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.746409] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.747412] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.748412] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.749444] pci 0000:00:02.0: Boot video device
[    0.750342] PCI: CLS 0 bytes, default 64
[    0.751188] Trying to unpack rootfs image as initramfs...
[    4.341389] Freeing initrd memory: 199808K (ffff880073ce0000 - ffff88008=
0000000)
[    4.342924] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.343961] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    4.346116] kvm: no hardware support
[    4.347628] Scanning for low memory corruption every 60 seconds
[    4.349139] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.350807] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    4.352672] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.355281] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.356326] PCLMULQDQ-NI instructions are not detected.
[    4.357249] AVX or AES-NI instructions are not detected.
[    4.358183] AVX instructions are not detected.
[    4.359023] AVX instructions are not detected.
[    4.359866] AVX instructions are not detected.
[    4.360738] AVX instructions are not detected.
[    4.383034] bounce pool size: 64 pages
[    4.383860] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.392359] VFS: Disk quotas dquot_6.5.2
[    4.393329] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.396616] NFS: Registering the id_resolver key type
[    4.397560] Key type id_resolver registered
[    4.398396] Key type id_legacy registered
[    4.399217] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.400336] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.402282] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.403468] fuse init (API version 7.22)
[    4.404832] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    4.407875] bio: create slab <bio-1> at 1
[    4.409244] Btrfs loaded
[    4.409930] msgmni has been set to 7887
[    4.414909] NET: Registered protocol family 38
[    4.415794] Key type asymmetric registered
[    4.416779] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.418389] io scheduler noop registered
[    4.419210] io scheduler deadline registered
[    4.420076] io scheduler cfq registered (default)
[    4.421336] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.422503] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.423783] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.425332] ACPI: Power Button [PWRF]
[    4.426455] GHES: HEST is not enabled!
[    4.427718] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.428745] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    4.431875] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.432922] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    4.436051] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.438868] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.446634] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.468957] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.473445] Non-volatile memory driver v1.3
[    4.478515] brd: module loaded
[    4.481812] loop: module loaded
[    4.482710] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.483684] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.484823] blk-mq: CPU -> queue map
[    4.485596]   CPU 0 -> Queue 0
[    4.486304]   CPU 1 -> Queue 0
[    4.487009]   CPU 2 -> Queue 0
[    4.487721]   CPU 3 -> Queue 0
[    4.489041]  vda: unknown partition table
[    4.491675] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.492710] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.493852] blk-mq: CPU -> queue map
[    4.494628]   CPU 0 -> Queue 0
[    4.495355]   CPU 1 -> Queue 0
[    4.496130]   CPU 2 -> Queue 0
[    4.496864]   CPU 3 -> Queue 0
[    4.498249]  vdb: unknown partition table
[    4.500867] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.501881] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.508418] blk-mq: CPU -> queue map
[    4.509167]   CPU 0 -> Queue 0
[    4.509852]   CPU 1 -> Queue 0
[    4.510540]   CPU 2 -> Queue 0
[    4.511223]   CPU 3 -> Queue 0
[    4.512606]  vdc: unknown partition table
[    4.515056] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.516033] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.517120] blk-mq: CPU -> queue map
[    4.517872]   CPU 0 -> Queue 0
[    4.518569]   CPU 1 -> Queue 0
[    4.519261]   CPU 2 -> Queue 0
[    4.519948]   CPU 3 -> Queue 0
[    4.521255]  vdd: unknown partition table
[    4.523636] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.524615] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    4.525696] blk-mq: CPU -> queue map
[    4.526452]   CPU 0 -> Queue 0
[    4.527150]   CPU 1 -> Queue 0
[    4.527900]   CPU 2 -> Queue 0
[    4.528620]   CPU 3 -> Queue 0
[    4.530047]  vde: unknown partition table
[    4.532388] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    4.533306] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    4.534336] blk-mq: CPU -> queue map
[    4.535054]   CPU 0 -> Queue 0
[    4.535720]   CPU 1 -> Queue 0
[    4.536402]   CPU 2 -> Queue 0
[    4.537077]   CPU 3 -> Queue 0
[    4.538281]  vdf: unknown partition table
[    4.540752] lkdtm: No crash points registered, enable through debugfs
[    4.542518] Loading iSCSI transport class v2.0-870.
[    4.544318] Adaptec aacraid driver 1.2-0[30200]-ms
[    4.545295] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.546567] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    4.548318] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.549884] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.551092] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    4.552346] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.553466] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.554947] ata_piix 0000:00:01.1: version 2.13
[    4.558098] scsi0 : ata_piix
[    4.558966] scsi1 : ata_piix
[    4.559784] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    4.560899] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    4.564093] tun: Universal TUN/TAP device driver, 1.6
[    4.565026] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.566527] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    4.567833] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.568823] Copyright (c) 2007 Atheros Corporation.
[    4.570252] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    4.571466] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    4.571466]   http://www.scyld.com/network/drivers.html
[    4.573808] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    4.575149] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.576216] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.577296] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    4.578452] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.716419] ata2.01: NODEV after polling detection
[    4.717554] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    4.718916] ata2.00: configured for MWDMA2
[    4.720427] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    4.723174] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[    4.904590] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    4.905786] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.907060] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.908127] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.909290] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    4.910445] igb: Copyright (c) 2007-2013 Intel Corporation.
[    4.911551] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    4.913137] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    4.914262] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    4.915430] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.916718] sky2: driver version 1.30
[    4.918776] usbcore: registered new interface driver catc
[    4.919879] usbcore: registered new interface driver kaweth
[    4.920956] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    4.922635] usbcore: registered new interface driver pegasus
[    4.923770] usbcore: registered new interface driver rtl8150
[    4.924928] usbcore: registered new interface driver asix
[    4.926033] usbcore: registered new interface driver ax88179_178a
[    4.927190] usbcore: registered new interface driver cdc_ether
[    4.928330] usbcore: registered new interface driver r815x
[    4.929354] usbcore: registered new interface driver cdc_eem
[    4.930382] usbcore: registered new interface driver dm9601
[    4.931404] usbcore: registered new interface driver smsc75xx
[    4.932515] usbcore: registered new interface driver smsc95xx
[    4.933561] usbcore: registered new interface driver gl620a
[    4.934584] usbcore: registered new interface driver net1080
[    4.935615] usbcore: registered new interface driver plusb
[    4.936683] usbcore: registered new interface driver rndis_host
[    4.937735] usbcore: registered new interface driver cdc_subset
[    4.938794] usbcore: registered new interface driver zaurus
[    4.939819] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    4.941407] usbcore: registered new interface driver int51x1
[    4.942439] usbcore: registered new interface driver ipheth
[    4.943465] usbcore: registered new interface driver sierra_net
[    4.944581] usbcore: registered new interface driver cdc_ncm
[    4.945559] Fusion MPT base driver 3.04.20
[    4.946367] Copyright (c) 1999-2008 LSI Corporation
[    4.947267] Fusion MPT SPI Host driver 3.04.20
[    4.948205] Fusion MPT FC Host driver 3.04.20
[    4.949151] Fusion MPT SAS Host driver 3.04.20
[    4.950067] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.951093] mptctl: Registered with Fusion MPT base driver
[    4.952067] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    4.953217] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.954274] ehci-pci: EHCI PCI platform driver
[    4.955177] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.956229] ohci-pci: OHCI PCI platform driver
[    4.957168] uhci_hcd: USB Universal Host Controller Interface driver
[    4.958340] usbcore: registered new interface driver usb-storage
[    4.959412] usbcore: registered new interface driver ums-alauda
[    4.960519] usbcore: registered new interface driver ums-datafab
[    4.961590] usbcore: registered new interface driver ums-freecom
[    4.962653] usbcore: registered new interface driver ums-isd200
[    4.963709] usbcore: registered new interface driver ums-jumpshot
[    4.964834] usbcore: registered new interface driver ums-sddr09
[    4.965890] usbcore: registered new interface driver ums-sddr55
[    4.966946] usbcore: registered new interface driver ums-usbat
[    4.968000] usbcore: registered new interface driver usbtest
[    4.969160] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.971402] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.972353] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.973615] mousedev: PS/2 mouse device common for all mice
[    4.975185] rtc_cmos 00:00: RTC can wake from S4
[    4.976400] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.977652] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.978822] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.980698] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.982159] i6300esb: initialized (0xffffc90000718000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    4.983867] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.985066] iTCO_vendor_support: vendor-support=3D0
[    4.985989] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.987604] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.989295] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    4.991187] md: linear personality registered for level -1
[    4.992186] md: raid0 personality registered for level 0
[    4.993109] md: raid1 personality registered for level 1
[    4.994105] md: raid10 personality registered for level 10
[    4.995347] md: raid6 personality registered for level 6
[    4.996377] md: raid5 personality registered for level 5
[    4.997327] md: raid4 personality registered for level 4
[    4.998251] md: multipath personality registered for level -4
[    4.999227] md: faulty personality registered for level -5
[    5.001263] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.003587] device-mapper: multipath: version 1.6.0 loaded
[    5.004642] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.005817] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    5.006913] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.008562] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.012013] usbcore: registered new interface driver usbhid
[    5.013072] usbhid: USB HID core driver
[    5.014080] TCP: bic registered
[    5.014847] Initializing XFRM netlink socket
[    5.016092] NET: Registered protocol family 10
[    5.017199] sit: IPv6 over IPv4 tunneling driver
[    5.018339] NET: Registered protocol family 17
[    5.019239] 8021q: 802.1Q VLAN Support v1.8
[    5.020364] sctp: Hash tables configured (established 65536 bind 65536)
[    5.021692] Key type dns_resolver registered
[    5.023335]=20
[    5.023335] printing PIC contents
[    5.024544] ... PIC  IMR: ffff
[    5.025246] ... PIC  IRR: 9113
[    5.025942] ... PIC  ISR: 0000
[    5.031953] ... PIC ELCR: 0c00
[    5.032674] printing local APIC contents on CPU#0/0:
[    5.033566] ... APIC ID:      00000000 (0)
[    5.034370] ... APIC VERSION: 00050014
[    5.035141] ... APIC TASKPRI: 00000000 (00)
[    5.035948] ... APIC PROCPRI: 00000000
[    5.036657] ... APIC LDR: 01000000
[    5.036657] ... APIC DFR: ffffffff
[    5.036657] ... APIC SPIV: 000001ff
[    5.036657] ... APIC ISR field:
[    5.036657] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.036657] ... APIC TMR field:
[    5.036657] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.036657] ... APIC IRR field:
[    5.036657] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.036657] ... APIC ESR: 00000000
[    5.036657] ... APIC ICR: 000008fd
[    5.036657] ... APIC ICR2: 02000000
[    5.036657] ... APIC LVTT: 000000ef
[    5.036657] ... APIC LVTPC: 00010000
[    5.036657] ... APIC LVT0: 00010700
[    5.036657] ... APIC LVT1: 00000400
[    5.036657] ... APIC LVTERR: 000000fe
[    5.036657] ... APIC TMICT: 00032fd7
[    5.036657] ... APIC TMCCT: 00000000
[    5.036657] ... APIC TDCR: 00000003
[    5.036657]=20
[    5.054881] number of MP IRQ sources: 15.
[    5.055678] number of IO-APIC #0 registers: 24.
[    5.056536] testing the IO APIC.......................
[    5.057449] IO APIC #0......
[    5.058126] .... register #00: 00000000
[    5.058903] .......    : physical APIC id: 00
[    5.059734] .......    : Delivery Type: 0
[    5.060546] .......    : LTS          : 0
[    5.061339] .... register #01: 00170011
[    5.062113] .......     : max redirection entries: 17
[    5.063008] .......     : PRQ implemented: 0
[    5.063824] .......     : IO APIC version: 11
[    5.064665] .... register #02: 00000000
[    5.065442] .......     : arbitration: 00
[    5.066236] .... IRQ redirection table:
[    5.067020] 1    0    0   0   0    0    0    00
[    5.067867] 0    0    0   0   0    1    1    31
[    5.068751] 0    0    0   0   0    1    1    30
[    5.069605] 0    0    0   0   0    1    1    33
[    5.070456] 1    0    0   0   0    1    1    34
[    5.071309] 1    1    0   0   0    1    1    35
[    5.072179] 0    0    0   0   0    1    1    36
[    5.073027] 0    0    0   0   0    1    1    37
[    5.073878] 0    0    0   0   0    1    1    38
[    5.074731] 0    1    0   0   0    1    1    39
[    5.075594] 1    1    0   0   0    1    1    3A
[    5.076460] 1    1    0   0   0    1    1    3B
[    5.077312] 0    0    0   0   0    1    1    3C
[    5.078167] 0    0    0   0   0    1    1    3D
[    5.079017] 0    0    0   0   0    1    1    3E
[    5.079869] 0    0    0   0   0    1    1    3F
[    5.080755] 1    0    0   0   0    0    0    00
[    5.081603] 1    0    0   0   0    0    0    00
[    5.082456] 1    0    0   0   0    0    0    00
[    5.083310] 1    0    0   0   0    0    0    00
[    5.084195] 1    0    0   0   0    0    0    00
[    5.085044] 1    0    0   0   0    0    0    00
[    5.085890] 1    0    0   0   0    0    0    00
[    5.086744] 1    0    0   0   0    0    0    00
[    5.087583] IRQ to pin mappings:
[    5.088303] IRQ0 -> 0:2
[    5.089063] IRQ1 -> 0:1
[    5.089821] IRQ3 -> 0:3
[    5.090588] IRQ4 -> 0:4
[    5.091352] IRQ5 -> 0:5
[    5.092123] IRQ6 -> 0:6
[    5.092889] IRQ7 -> 0:7
[    5.093650] IRQ8 -> 0:8
[    5.094417] IRQ9 -> 0:9
[    5.095180] IRQ10 -> 0:10
[    5.095965] IRQ11 -> 0:11
[    5.096755] IRQ12 -> 0:12
[    5.097533] IRQ13 -> 0:13
[    5.098331] IRQ14 -> 0:14
[    5.099112] IRQ15 -> 0:15
[    5.099885] .................................... done.
[    5.101168] registered taskstats version 1
[    5.103575] rtc_cmos 00:00: setting system clock to 2014-01-04 23:12:47 =
UTC (1388877167)
[    5.105140] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    5.109933] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.110921] 8021q: adding VLAN 0 to HW filter on device eth0
[    5.344107] tsc: Refined TSC clocksource calibration: 2693.408 MHz
[    5.602302] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.112577] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    7.116155] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.132092] Sending DHCP requests ., OK
[    7.196097] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    7.197345] IP-Config: Complete:
[    7.198064]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.199731]      host=3Dvpx-2, domain=3D, nis-domain=3D(none)
[    7.200665]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    7.201368]      nameserver0=3D10.0.2.3
[    7.202594] PM: Hibernation image not present or could not be loaded.
[    7.204953] Freeing unused kernel memory: 1428K (ffffffff82336000 - ffff=
ffff8249b000)
[    7.206479] Write protecting the kernel read-only data: 18432k
[    7.211854] Freeing unused kernel memory: 1972K (ffff880001a13000 - ffff=
880001c00000)
[    7.217268] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff=
880002200000)
[    7.411025] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.412746] platform microcode: Direct firmware load failed with error -2
[    7.414525] platform microcode: Falling back to user helper
[    7.451244] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.452358] platform microcode: Direct firmware load failed with error -2
[    7.453521] platform microcode: Falling back to user helper
[    7.457706] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.458971] platform microcode: Direct firmware load failed with error -2
[    7.460055] platform microcode: Falling back to user helper
[    7.464368] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.465355] platform microcode: Direct firmware load failed with error -2
[    7.466441] platform microcode: Falling back to user helper
[    7.470755] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    7.747212] random: vgscan urandom read with 20 bits of entropy available

=3D=3D> /tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /tmp/err_log <=3D=3D

=3D=3D> /tmp/run_log <=3D=3D
downloading latest lkp src code
Files /etc/init.d/nfsroot and /lkp/lkp/src/rootfs/addon/etc/init.d/nfsroot =
differ
find a new version of this script, reloading...
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-btrfs-generic-mid/x86_64-=
lkp/c40bbf4184be2c0a2ee0740299e46721711518ff/0
job=3D/lkp/scheduled/vpx-2/cyclic_xfstests-generic-4HDD-btrfs-generic-mid-H=
EAD.yaml
2014-01-04 23:13:01 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/vpx-2/cyclic_xfstests-generic-4HDD-btrfs-generic-mid=
-HEAD.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/fs
2014-01-04 23:13:02 mkfs -t btrfs /dev/vdb
2014-01-04 23:13:02 mkfs -t btrfs /dev/vdc
2014-01-04 23:13:02 mkfs -t btrfs /dev/vda
2014-01-04 23:13:02 mkfs -t btrfs /dev/vdd
run: /lkp/lkp/src/monitors/event/wait pre-test

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdb

Btrfs v0.20-rc1-566-gd1570a0
[   20.156662] btrfs: device fsid fcbe3cbe-bfe8-4424-8729-b558fd917ef8=20
WARNING! - Btrdevid 1 transid 4 /dev/vdb
fs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdc

Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdd

Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-g
[   20.173598] btrfs: device fsid e3924a34-94e4-488e-a2b4-08efb1a9fbee d157=
0a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vda

Btrfs v0.20-rc1-566-gd1570a0
devid 1 transid 4 /dev/vdc
[   20.176480] btrfs: device fsid f0e06999-0518-47e0-a622-21b8749438be devi=
d 1 transid 4 /dev/vda
[   20.178637] btrfs: device fsid 54062708-596b-4ab7-a83d-05def9e09c38 devi=
d 1 transid 4 /dev/vdd
2014-01-04 23:13:02 mount -t btrfs /dev/vda /fs/vda
[   20.184264] btrfs: device fsid f0e06999-0518-47e0-a622-21b8749438be devi=
d 1 transid 4 /dev/vda
[   20.186552] btrfs: disk space caching is enabled
[  131.360457] random: nonblocking pool is initialized
[ 1465.069342] SysRq : Emergency Sync
[ 1475.071055] SysRq : Resetting

BUG: kernel test crashed
Elapsed time: 1485
numactl --preferred=3D1 --physcpubind=3D8-11 qemu-system-x86_64 -cpu kvm64 =
-enable-kvm -kernel /kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e467217115=
18ff/vmlinuz-3.13.0-rc6-wl-02230-gc40bbf4 -append 'user=3Dlkp job=3D/lkp/sc=
heduled/vpx-2/cyclic_xfstests-generic-4HDD-btrfs-generic-mid-HEAD.yaml ARCH=
=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e467217=
11518ff/vmlinuz-3.13.0-rc6-wl-02230-gc40bbf4 kconfig=3Dx86_64-lkp commit=3D=
c40bbf4184be2c0a2ee0740299e46721711518ff bm_initrd=3D/lkp/benchmarks/xfstes=
ts.cgz modules_initrd=3D/kernel/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721=
711518ff/modules.cgz max_uptime=3D1269 RESULT_ROOT=3D/lkp/result/vpx/micro/=
xfstests/4HDD-btrfs-generic-mid/x86_64-lkp/c40bbf4184be2c0a2ee0740299e46721=
711518ff/0 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=
=3D::::vpx-2::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddeb=
ug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 cons=
ole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal'  -initrd /fs/sdc1/initrd-vp=
x-2 -m 4G -smp 4 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=
=3Dtcp::9466-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -drive file=3D/fs/sdc1/disk0-vpx-2,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/sdc1/disk1-vpx-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/sdc1/disk2-vpx-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk3-vpx=
-2,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk4-vpx-2,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/sdc1/disk5-vpx-2,media=3Ddisk,if=3Dvirtio -p=
idfile /dev/shm/kboot/pid-vpx-2 -serial file:/dev/shm/kboot/serial-vpx-2 -d=
aemonize -display none -monitor null=20

--qDbXVdCdHGoSgWSk--
