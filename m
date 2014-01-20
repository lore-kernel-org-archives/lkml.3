Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaATX2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:28:53 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55739 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbaATX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:28:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhprAJWw3VJ20iCRPGdsb2JhbABZgwuEC4Q6tCCBDhcDAQEBATg1giUBAQEEGgEIBC8eBAEQCAMOBgQJFgQHAgIJAwIBAgEnChQGDQEFAgIXh1YDEKd0ljALhVgXjicKBTgMBQeCb4FJBIUrixCEAZAgh02BUSmBLAEBHgY
Message-ID: <52DDB126.4010901@internode.on.net>
Date: Tue, 21 Jan 2014 09:58:38 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Anssi Hannula <anssi.hannula@iki.fi>,
        ALSA devel <alsa-devel@alsa-project.org>, xorg-driver-ati@lists.x.org,
        linux-kernel@vger.kernel.org
Subject: Re: ALSA: hda - Fix possible races in HDMI driver - lockup on shutdown
 when radeon.audio=1 after using audacity
References: <52DB7878.8000004@internode.on.net> <s5hha8zox0j.wl%tiwai@suse.de>
In-Reply-To: <s5hha8zox0j.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------090104030600010207030603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090104030600010207030603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Takashi Iwai wrote, on 20/01/14 19:22:
> At Sun, 19 Jan 2014 17:32:16 +1030,
> Arthur Marsh wrote:
>>
>> I have had reproducible lock-ups on shut-down (at the shutting down ALSA
>> stage) of my AMD64 machine (Asus M3A78Pro motherboard, BIOS 1701
>> 01/27/2011, CPU AMD Athlon(tm) II X4 640 Processor) running the 64 bit
>> Linux kernel more recent than 3.12 when *both* radeon.audio=1 was set
>> and I had been running audacity 2.0.5. (iommu=noaperture is also set).
>>
>> The problem was reproducible with the stock Debian kernel
>> linux-image-3.13-rc6-amd64 version 3.13~rc6-1~exp1.
>>
>> The machine is using an ATI/AMD 3850HD video card with a DVI cable to a
>> DVI input on my monitor, and the default audio device is the
>> motherboard's on-board audio device:
>>
>> 00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
>> Azalia (Intel HDA)
>>
>> 01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
>> [AMD/ATI] RV670 [Radeon HD 3690/3850]
>> 01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RV670/680
>> HDMI Audio [Radeon HD 3690/3800 Series]
>>
>> $ git bisect bad
>> cbbaa603a03cc46681e24d6b2804b62fde95a2af is the first bad commit
>> commit cbbaa603a03cc46681e24d6b2804b62fde95a2af
>> Author: Takashi Iwai <tiwai@suse.de>
>> Date:   Thu Oct 17 18:03:24 2013 +0200
>>
>>       ALSA: hda - Fix possible races in HDMI driver
>>
>>       Some per_pin fields and ELD contents might be changed dynamically in
>>       multiple ways where the concurrent accesses are still opened in the
>>       current code.  This patch fixes such possible races by using eld->lock
>>       in appropriate places.
>>
>>       Reported-by: Anssi Hannula <anssi.hannula@iki.fi>
>>       Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>
>> :040000 040000 0c29281f82a3ebd9a704d481114f9cfcefea07c8
>> d71fd101125cd29a628cb5e66c7ee4f56e28329b M      sound
>>
>> When running audacity from the command line there was the following output:
>>
>> ALSA lib pcm_dsnoop.c:618:(snd_pcm_dsnoop_open) unable to open slave
>> ALSA lib pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
>> ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.rear
>> ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.center_lfe
>> ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.side
>> ALSA lib pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
>> Expression 'stream->playback.pcm' failed in
>> 'src/hostapi/alsa/pa_linux_alsa.c', line: 4611
>> Expression 'stream->playback.pcm' failed in
>> 'src/hostapi/alsa/pa_linux_alsa.c', line: 4611
>> Expression 'stream->playback.pcm' failed in
>> 'src/hostapi/alsa/pa_linux_alsa.c', line: 4611
>>
>> I am happy to supply further information or run further tests to help in
>> isolating the problem and verifying a solution.
>
> Could you build the kernel with lockdep kconfig and see whether it
> reports errors?
>
> Reverting the commit doesn't work cleanly.  Instead, you can try to
> simply comment out all mutex_lock(&per_pin->lock) and
> mutex_unlock(&per_pin->lock) calls in patch_hdmi.c to see whether it's
> a mutex deadlock.
>
>
> thanks,
>
> Takashi
>

I'm not 100% sure on lockdep kconfig, but I did get this on shut-down of 
the 3.13 kernel (full kern.log from boot-up).

Regards,

Arthur.

--------------090104030600010207030603
Content-Type: text/plain; charset=UTF-8;
 name="alsa-lock.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-lock.log"

Jan 21 09:35:31 am64 kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan 21 09:35:31 am64 kernel: [    0.000000] Initializing cgroup subsys cpu
Jan 21 09:35:31 am64 kernel: [    0.000000] Initializing cgroup subsys cpuacct
Jan 21 09:35:31 am64 kernel: [    0.000000] Linux version 3.13.0 (root@am64) (gcc version 4.8.2 (Debian 4.8.2-14) ) #633 SMP Mon Jan 20 19:49:22 CST 2014
Jan 21 09:35:31 am64 kernel: [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.13.0-rc8+ root=UUID=39706f53-7c27-4310-b22a-36c7b042d1a1 ro iommu=noaperture radeon.audio=1
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: BIOS-provided physical RAM map:
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009efff] usable
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cffaffff] usable
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x00000000cffb0000-0x00000000cffbdfff] ACPI data
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x00000000cffbe000-0x00000000cffdffff] ACPI NVS
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x00000000cffe0000-0x00000000cfffffff] reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
Jan 21 09:35:31 am64 kernel: [    0.000000] NX (Execute Disable) protection: active
Jan 21 09:35:31 am64 kernel: [    0.000000] SMBIOS 2.5 present.
Jan 21 09:35:31 am64 kernel: [    0.000000] DMI: System manufacturer System Product Name/M3A78 PRO, BIOS 1701    01/27/2011
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
Jan 21 09:35:31 am64 kernel: [    0.000000] MTRR default type: uncachable
Jan 21 09:35:31 am64 kernel: [    0.000000] MTRR fixed ranges enabled:
Jan 21 09:35:31 am64 kernel: [    0.000000]   00000-9FFFF write-back
Jan 21 09:35:31 am64 kernel: [    0.000000]   A0000-EFFFF uncachable
Jan 21 09:35:31 am64 kernel: [    0.000000]   F0000-FFFFF write-protect
Jan 21 09:35:31 am64 kernel: [    0.000000] MTRR variable ranges enabled:
Jan 21 09:35:31 am64 kernel: [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
Jan 21 09:35:31 am64 kernel: [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
Jan 21 09:35:31 am64 kernel: [    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
Jan 21 09:35:31 am64 kernel: [    0.000000]   3 disabled
Jan 21 09:35:31 am64 kernel: [    0.000000]   4 disabled
Jan 21 09:35:31 am64 kernel: [    0.000000]   5 disabled
Jan 21 09:35:31 am64 kernel: [    0.000000]   6 disabled
Jan 21 09:35:31 am64 kernel: [    0.000000]   7 disabled
Jan 21 09:35:31 am64 kernel: [    0.000000] TOM2: 0000000230000000 aka 8960M
Jan 21 09:35:31 am64 kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: last_pfn = 0xcffb0 max_arch_pfn = 0x400000000
Jan 21 09:35:31 am64 kernel: [    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
Jan 21 09:35:31 am64 kernel: [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 28672
Jan 21 09:35:31 am64 kernel: [    0.000000] Using GB pages for direct mapping
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f32d000, 0x22f32dfff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f32e000, 0x22f32efff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f32f000, 0x22f32ffff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x22fe00000-0x22fffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x22fe00000-0x22fffffff] page 2M
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f330000, 0x22f330fff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x22c000000-0x22fdfffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x22c000000-0x22fdfffff] page 2M
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x200000000-0x22bffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x200000000-0x22bffffff] page 2M
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x00100000-0xcffaffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0xcfe00000-0xcffaffff] page 4k
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f331000, 0x22f331fff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] BRK [0x22f332000, 0x22f332fff] PGTABLE
Jan 21 09:35:31 am64 kernel: [    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
Jan 21 09:35:31 am64 kernel: [    0.000000] RAMDISK: [mem 0x22d2dc000-0x22dffefff]
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: RSDP 00000000000fa820 000024 (v02 ACPIAM)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: XSDT 00000000cffb0100 00005C (v01 012711 OEMXSDT  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: FACP 00000000cffb0290 0000F4 (v03 012711 OEMFACP  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: DSDT 00000000cffb0450 0090C5 (v01  P0020 P0020000 00000000 INTL 20051117)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: FACS 00000000cffbe000 000040
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: APIC 00000000cffb0390 00007C (v01 012711 OEMAPIC  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: MCFG 00000000cffb0410 00003C (v01 012711 OEMMCFG  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: OEMB 00000000cffbe040 000071 (v01 012711 AMI_OEM  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: SRAT 00000000cffb9520 0000E8 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: HPET 00000000cffb9610 000038 (v01 012711 OEMHPET  20110127 MSFT 00000097)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: SSDT 00000000cffb9650 00088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 21 09:35:31 am64 kernel: [    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880225200000-ffff88022c3fffff] on node 0
Jan 21 09:35:31 am64 kernel: [    0.000000] Zone ranges:
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] Movable zone start for each node
Jan 21 09:35:31 am64 kernel: [    0.000000] Early memory node ranges
Jan 21 09:35:31 am64 kernel: [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
Jan 21 09:35:31 am64 kernel: [    0.000000]   node   0: [mem 0x00100000-0xcffaffff]
Jan 21 09:35:31 am64 kernel: [    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] On node 0 totalpages: 2096974
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA zone: 22 pages reserved
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA32 zone: 11591 pages used for memmap
Jan 21 09:35:31 am64 kernel: [    0.000000]   DMA32 zone: 847792 pages, LIFO batch:31
Jan 21 09:35:31 am64 kernel: [    0.000000]   Normal zone: 17024 pages used for memmap
Jan 21 09:35:31 am64 kernel: [    0.000000]   Normal zone: 1245184 pages, LIFO batch:31
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Jan 21 09:35:31 am64 kernel: [    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 21 09:35:31 am64 kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan 21 09:35:31 am64 kernel: [    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
Jan 21 09:35:31 am64 kernel: [    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
Jan 21 09:35:31 am64 kernel: [    0.000000] nr_irqs_gsi: 40
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcffb0000-0xcffbdfff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcffbe000-0xcffdffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcffe0000-0xcfffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xff6fffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xff700000-0xffffffff]
Jan 21 09:35:31 am64 kernel: [    0.000000] e820: [mem 0xd0000000-0xff6fffff] available for PCI devices
Jan 21 09:35:31 am64 kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Jan 21 09:35:31 am64 kernel: [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_node_ids:1
Jan 21 09:35:31 am64 kernel: [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88022fc00000 s83456 r8192 d23040 u262144
Jan 21 09:35:31 am64 kernel: [    0.000000] pcpu-alloc: s83456 r8192 d23040 u262144 alloc=1*2097152
Jan 21 09:35:31 am64 kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
Jan 21 09:35:31 am64 kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2068281
Jan 21 09:35:31 am64 kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.13.0-rc8+ root=UUID=39706f53-7c27-4310-b22a-36c7b042d1a1 ro iommu=noaperture radeon.audio=1
Jan 21 09:35:31 am64 kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan 21 09:35:31 am64 kernel: [    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Jan 21 09:35:31 am64 kernel: [    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jan 21 09:35:31 am64 kernel: [    0.000000] Memory: 8158124K/8387896K available (4738K kernel code, 642K rwdata, 2120K rodata, 856K init, 7868K bss, 229772K reserved)
Jan 21 09:35:31 am64 kernel: [    0.000000] Hierarchical RCU implementation.
Jan 21 09:35:31 am64 kernel: [    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
Jan 21 09:35:31 am64 kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Jan 21 09:35:31 am64 kernel: [    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
Jan 21 09:35:31 am64 kernel: [    0.000000] NR_IRQS:4352 nr_irqs:728 16
Jan 21 09:35:31 am64 kernel: [    0.000000] Console: colour VGA+ 80x25
Jan 21 09:35:31 am64 kernel: [    0.000000] console [tty0] enabled
Jan 21 09:35:31 am64 kernel: [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Jan 21 09:35:31 am64 kernel: [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
Jan 21 09:35:31 am64 kernel: [    0.000000] ... MAX_LOCK_DEPTH:          48
Jan 21 09:35:31 am64 kernel: [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
Jan 21 09:35:31 am64 kernel: [    0.000000] ... CLASSHASH_SIZE:          4096
Jan 21 09:35:31 am64 kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
Jan 21 09:35:31 am64 kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
Jan 21 09:35:31 am64 kernel: [    0.000000] ... CHAINHASH_SIZE:          16384
Jan 21 09:35:31 am64 kernel: [    0.000000]  memory used by lock dependency info: 5823 kB
Jan 21 09:35:31 am64 kernel: [    0.000000]  per task-struct memory footprint: 1920 bytes
Jan 21 09:35:31 am64 kernel: [    0.000000] allocated 33554432 bytes of page_cgroup
Jan 21 09:35:31 am64 kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Jan 21 09:35:31 am64 kernel: [    0.000000] hpet clockevent registered
Jan 21 09:35:31 am64 kernel: [    0.000000] tsc: Fast TSC calibration using PIT
Jan 21 09:35:31 am64 kernel: [    0.004000] tsc: Detected 3007.678 MHz processor
Jan 21 09:35:31 am64 kernel: [    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6015.35 BogoMIPS (lpj=12030712)
Jan 21 09:35:31 am64 kernel: [    0.000076] pid_max: default: 32768 minimum: 301
Jan 21 09:35:31 am64 kernel: [    0.000171] Security Framework initialized
Jan 21 09:35:31 am64 kernel: [    0.000213] AppArmor: AppArmor disabled by boot time parameter
Jan 21 09:35:31 am64 kernel: [    0.000249] Yama: becoming mindful.
Jan 21 09:35:31 am64 kernel: [    0.000309] Mount-cache hash table entries: 256
Jan 21 09:35:31 am64 kernel: [    0.000679] Initializing cgroup subsys memory
Jan 21 09:35:31 am64 kernel: [    0.000725] Initializing cgroup subsys devices
Jan 21 09:35:31 am64 kernel: [    0.000765] Initializing cgroup subsys freezer
Jan 21 09:35:31 am64 kernel: [    0.000804] Initializing cgroup subsys net_cls
Jan 21 09:35:31 am64 kernel: [    0.000840] Initializing cgroup subsys blkio
Jan 21 09:35:31 am64 kernel: [    0.000876] Initializing cgroup subsys perf_event
Jan 21 09:35:31 am64 kernel: [    0.000940] tseg: 0000000000
Jan 21 09:35:31 am64 kernel: [    0.000958] CPU: Physical Processor ID: 0
Jan 21 09:35:31 am64 kernel: [    0.000996] CPU: Processor Core ID: 3
Jan 21 09:35:31 am64 kernel: [    0.001031] mce: CPU supports 6 MCE banks
Jan 21 09:35:31 am64 kernel: [    0.001070] LVT offset 0 assigned for vector 0xf9
Jan 21 09:35:31 am64 kernel: [    0.001108] process: using AMD E400 aware idle routine
Jan 21 09:35:31 am64 kernel: [    0.001144] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Jan 21 09:35:31 am64 kernel: [    0.001144] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
Jan 21 09:35:31 am64 kernel: [    0.001144] tlb_flushall_shift: 4
Jan 21 09:35:31 am64 kernel: [    0.001271] Freeing SMP alternatives memory: 16K (ffffffff81b78000 - ffffffff81b7c000)
Jan 21 09:35:31 am64 kernel: [    0.001958] ACPI: Core revision 20131115
Jan 21 09:35:31 am64 kernel: [    0.005688] ACPI: All ACPI Tables successfully acquired
Jan 21 09:35:31 am64 kernel: [    0.006310] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 21 09:35:31 am64 kernel: [    0.045980] smpboot: CPU0: AMD Athlon(tm) II X4 640 Processor (fam: 10, model: 05, stepping: 03)
Jan 21 09:35:31 am64 kernel: [    0.151109] Performance Events: AMD PMU driver.
Jan 21 09:35:31 am64 kernel: [    0.151182] ... version:                0
Jan 21 09:35:31 am64 kernel: [    0.151217] ... bit width:              48
Jan 21 09:35:31 am64 kernel: [    0.151251] ... generic registers:      4
Jan 21 09:35:31 am64 kernel: [    0.151286] ... value mask:             0000ffffffffffff
Jan 21 09:35:31 am64 kernel: [    0.151321] ... max period:             00007fffffffffff
Jan 21 09:35:31 am64 kernel: [    0.151356] ... fixed-purpose events:   0
Jan 21 09:35:31 am64 kernel: [    0.151390] ... event mask:             000000000000000f
Jan 21 09:35:31 am64 kernel: [    0.151923] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Jan 21 09:35:31 am64 kernel: [    0.152174] x86: Booting SMP configuration:
Jan 21 09:35:31 am64 kernel: [    0.165498] process: System has AMD C1E enabled
Jan 21 09:35:31 am64 kernel: [    0.165611] process: Switch to broadcast mode on CPU1
Jan 21 09:35:31 am64 kernel: [    0.178669] process: Switch to broadcast mode on CPU2
Jan 21 09:35:31 am64 kernel: [    0.152214] .... node  #0, CPUs:      #1 #2 #3
Jan 21 09:35:31 am64 kernel: [    0.191833] x86: Booted up 1 node, 4 CPUs
Jan 21 09:35:31 am64 kernel: [    0.191905] smpboot: Total of 4 processors activated (24061.42 BogoMIPS)
Jan 21 09:35:31 am64 kernel: [    0.191978] process: Switch to broadcast mode on CPU3
Jan 21 09:35:31 am64 kernel: [    0.192952] process: Switch to broadcast mode on CPU0
Jan 21 09:35:31 am64 kernel: [    0.194039] devtmpfs: initialized
Jan 21 09:35:31 am64 kernel: [    0.200436] PM: Registering ACPI NVS region [mem 0xcffbe000-0xcffdffff] (139264 bytes)
Jan 21 09:35:31 am64 kernel: [    0.200864] NET: Registered protocol family 16
Jan 21 09:35:31 am64 kernel: [    0.201073] cpuidle: using governor ladder
Jan 21 09:35:31 am64 kernel: [    0.201112] cpuidle: using governor menu
Jan 21 09:35:31 am64 kernel: [    0.201150] node 0 link 0: io port [1000, ffffff]
Jan 21 09:35:31 am64 kernel: [    0.201153] TOM: 00000000d0000000 aka 3328M
Jan 21 09:35:31 am64 kernel: [    0.201189] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
Jan 21 09:35:31 am64 kernel: [    0.201191] node 0 link 0: mmio [a0000, bffff]
Jan 21 09:35:31 am64 kernel: [    0.201194] node 0 link 0: mmio [d0000000, dfffffff]
Jan 21 09:35:31 am64 kernel: [    0.201197] node 0 link 0: mmio [e0000000, efffffff] ==> none
Jan 21 09:35:31 am64 kernel: [    0.201199] node 0 link 0: mmio [f0000000, ffefffff]
Jan 21 09:35:31 am64 kernel: [    0.201201] TOM2: 0000000230000000 aka 8960M
Jan 21 09:35:31 am64 kernel: [    0.201236] bus: [bus 00-07] on node 0 link 0
Jan 21 09:35:31 am64 kernel: [    0.201238] bus: 00 [io  0x0000-0xffff]
Jan 21 09:35:31 am64 kernel: [    0.201240] bus: 00 [mem 0x000a0000-0x000bffff]
Jan 21 09:35:31 am64 kernel: [    0.201241] bus: 00 [mem 0xd0000000-0xdfffffff]
Jan 21 09:35:31 am64 kernel: [    0.201243] bus: 00 [mem 0xf0000000-0xffffffff]
Jan 21 09:35:31 am64 kernel: [    0.201244] bus: 00 [mem 0x230000000-0xfcffffffff]
Jan 21 09:35:31 am64 kernel: [    0.201307] ACPI: bus type PCI registered
Jan 21 09:35:31 am64 kernel: [    0.201343] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Jan 21 09:35:31 am64 kernel: [    0.201537] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jan 21 09:35:31 am64 kernel: [    0.201613] PCI: not using MMCONFIG
Jan 21 09:35:31 am64 kernel: [    0.201649] PCI: Using configuration type 1 for base access
Jan 21 09:35:31 am64 kernel: [    0.201685] PCI: Using configuration type 1 for extended access
Jan 21 09:35:31 am64 kernel: [    0.202999] bio: create slab <bio-0> at 0
Jan 21 09:35:31 am64 kernel: [    0.203348] ACPI: Added _OSI(Module Device)
Jan 21 09:35:31 am64 kernel: [    0.203384] ACPI: Added _OSI(Processor Device)
Jan 21 09:35:31 am64 kernel: [    0.203421] ACPI: Added _OSI(3.0 _SCP Extensions)
Jan 21 09:35:31 am64 kernel: [    0.203456] ACPI: Added _OSI(Processor Aggregator Device)
Jan 21 09:35:31 am64 kernel: [    0.208390] ACPI: Executed 2 blocks of module-level executable AML code
Jan 21 09:35:31 am64 kernel: [    0.212186] ACPI BIOS Warning (bug): Incorrect checksum in table [OEMB] - 0x23, should be 0x22 (20131115/tbprint-214)
Jan 21 09:35:31 am64 kernel: [    0.212494] ACPI: Interpreter enabled
Jan 21 09:35:31 am64 kernel: [    0.212544] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
Jan 21 09:35:31 am64 kernel: [    0.212679] ACPI: (supports S0 S1 S3 S4 S5)
Jan 21 09:35:31 am64 kernel: [    0.212714] ACPI: Using IOAPIC for interrupt routing
Jan 21 09:35:31 am64 kernel: [    0.212822] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jan 21 09:35:31 am64 kernel: [    0.214128] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
Jan 21 09:35:31 am64 kernel: [    0.230012] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 21 09:35:31 am64 kernel: [    0.230211] ACPI: No dock devices found.
Jan 21 09:35:31 am64 kernel: [    0.239035] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jan 21 09:35:31 am64 kernel: [    0.239084] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
Jan 21 09:35:31 am64 kernel: [    0.239136] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
Jan 21 09:35:31 am64 kernel: [    0.239695] PCI host bridge to bus 0000:00
Jan 21 09:35:31 am64 kernel: [    0.239732] pci_bus 0000:00: root bus resource [bus 00-ff]
Jan 21 09:35:31 am64 kernel: [    0.239769] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Jan 21 09:35:31 am64 kernel: [    0.239805] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Jan 21 09:35:31 am64 kernel: [    0.239842] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Jan 21 09:35:31 am64 kernel: [    0.239879] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
Jan 21 09:35:31 am64 kernel: [    0.239916] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
Jan 21 09:35:31 am64 kernel: [    0.239952] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.240001] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.240200] pci 0000:00:02.0: [1022:9603] type 01 class 0x060400
Jan 21 09:35:31 am64 kernel: [    0.240247] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
Jan 21 09:35:31 am64 kernel: [    0.240331] pci 0000:00:02.0: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.240418] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
Jan 21 09:35:31 am64 kernel: [    0.240464] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
Jan 21 09:35:31 am64 kernel: [    0.240538] pci 0000:00:06.0: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.240643] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
Jan 21 09:35:31 am64 kernel: [    0.240667] pci 0000:00:11.0: reg 0x10: [io  0xc000-0xc007]
Jan 21 09:35:31 am64 kernel: [    0.240679] pci 0000:00:11.0: reg 0x14: [io  0xb000-0xb003]
Jan 21 09:35:31 am64 kernel: [    0.240690] pci 0000:00:11.0: reg 0x18: [io  0xa000-0xa007]
Jan 21 09:35:31 am64 kernel: [    0.240700] pci 0000:00:11.0: reg 0x1c: [io  0x9000-0x9003]
Jan 21 09:35:31 am64 kernel: [    0.240711] pci 0000:00:11.0: reg 0x20: [io  0x8000-0x800f]
Jan 21 09:35:31 am64 kernel: [    0.240723] pci 0000:00:11.0: reg 0x24: [mem 0xfe9ff800-0xfe9ffbff]
Jan 21 09:35:31 am64 kernel: [    0.240891] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
Jan 21 09:35:31 am64 kernel: [    0.240907] pci 0000:00:12.0: reg 0x10: [mem 0xfe9fe000-0xfe9fefff]
Jan 21 09:35:31 am64 kernel: [    0.241037] pci 0000:00:12.0: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.241121] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
Jan 21 09:35:31 am64 kernel: [    0.241137] pci 0000:00:12.1: reg 0x10: [mem 0xfe9fd000-0xfe9fdfff]
Jan 21 09:35:31 am64 kernel: [    0.241269] pci 0000:00:12.1: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.241356] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
Jan 21 09:35:31 am64 kernel: [    0.241378] pci 0000:00:12.2: reg 0x10: [mem 0xfe9ff000-0xfe9ff0ff]
Jan 21 09:35:31 am64 kernel: [    0.241473] pci 0000:00:12.2: supports D1 D2
Jan 21 09:35:31 am64 kernel: [    0.241475] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Jan 21 09:35:31 am64 kernel: [    0.241572] pci 0000:00:12.2: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.241660] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
Jan 21 09:35:31 am64 kernel: [    0.241676] pci 0000:00:13.0: reg 0x10: [mem 0xfe9fc000-0xfe9fcfff]
Jan 21 09:35:31 am64 kernel: [    0.241807] pci 0000:00:13.0: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.241889] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
Jan 21 09:35:31 am64 kernel: [    0.241904] pci 0000:00:13.1: reg 0x10: [mem 0xfe9fb000-0xfe9fbfff]
Jan 21 09:35:31 am64 kernel: [    0.242036] pci 0000:00:13.1: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.242123] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
Jan 21 09:35:31 am64 kernel: [    0.242145] pci 0000:00:13.2: reg 0x10: [mem 0xfe9fa800-0xfe9fa8ff]
Jan 21 09:35:31 am64 kernel: [    0.242240] pci 0000:00:13.2: supports D1 D2
Jan 21 09:35:31 am64 kernel: [    0.242242] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jan 21 09:35:31 am64 kernel: [    0.242317] pci 0000:00:13.2: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.242408] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
Jan 21 09:35:31 am64 kernel: [    0.242476] pci 0000:00:14.0: reg 0x30: [mem 0x00000000-0x000007ff pref]
Jan 21 09:35:31 am64 kernel: [    0.242601] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
Jan 21 09:35:31 am64 kernel: [    0.242621] pci 0000:00:14.1: reg 0x10: [io  0x0000-0x0007]
Jan 21 09:35:31 am64 kernel: [    0.242631] pci 0000:00:14.1: reg 0x14: [io  0x0000-0x0003]
Jan 21 09:35:31 am64 kernel: [    0.242642] pci 0000:00:14.1: reg 0x18: [io  0x0000-0x0007]
Jan 21 09:35:31 am64 kernel: [    0.242653] pci 0000:00:14.1: reg 0x1c: [io  0x0000-0x0003]
Jan 21 09:35:31 am64 kernel: [    0.242664] pci 0000:00:14.1: reg 0x20: [io  0xff00-0xff0f]
Jan 21 09:35:31 am64 kernel: [    0.242824] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
Jan 21 09:35:31 am64 kernel: [    0.242848] pci 0000:00:14.2: reg 0x10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
Jan 21 09:35:31 am64 kernel: [    0.242924] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
Jan 21 09:35:31 am64 kernel: [    0.242998] pci 0000:00:14.2: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.243080] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
Jan 21 09:35:31 am64 kernel: [    0.243261] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
Jan 21 09:35:31 am64 kernel: [    0.243366] pci 0000:00:14.4: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.243449] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
Jan 21 09:35:31 am64 kernel: [    0.243465] pci 0000:00:14.5: reg 0x10: [mem 0xfe9f9000-0xfe9f9fff]
Jan 21 09:35:31 am64 kernel: [    0.243597] pci 0000:00:14.5: System wakeup disabled by ACPI
Jan 21 09:35:31 am64 kernel: [    0.243686] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.243800] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.243908] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.244015] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.244128] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
Jan 21 09:35:31 am64 kernel: [    0.244306] pci 0000:01:00.0: [1002:9505] type 00 class 0x030000
Jan 21 09:35:31 am64 kernel: [    0.244319] pci 0000:01:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.244330] pci 0000:01:00.0: reg 0x18: [mem 0xfeaf0000-0xfeafffff 64bit]
Jan 21 09:35:31 am64 kernel: [    0.244337] pci 0000:01:00.0: reg 0x20: [io  0xd000-0xd0ff]
Jan 21 09:35:31 am64 kernel: [    0.244350] pci 0000:01:00.0: reg 0x30: [mem 0xfeac0000-0xfeadffff pref]
Jan 21 09:35:31 am64 kernel: [    0.244380] pci 0000:01:00.0: supports D1 D2
Jan 21 09:35:31 am64 kernel: [    0.244439] pci 0000:01:00.1: [1002:aa18] type 00 class 0x040300
Jan 21 09:35:31 am64 kernel: [    0.244452] pci 0000:01:00.1: reg 0x10: [mem 0xfeaec000-0xfeaeffff 64bit]
Jan 21 09:35:31 am64 kernel: [    0.244507] pci 0000:01:00.1: supports D1 D2
Jan 21 09:35:31 am64 kernel: [    0.249597] pci 0000:00:02.0: PCI bridge to [bus 01]
Jan 21 09:35:31 am64 kernel: [    0.249643] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
Jan 21 09:35:31 am64 kernel: [    0.249647] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
Jan 21 09:35:31 am64 kernel: [    0.249652] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.249756] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
Jan 21 09:35:31 am64 kernel: [    0.249773] pci 0000:02:00.0: reg 0x10: [io  0xe800-0xe8ff]
Jan 21 09:35:31 am64 kernel: [    0.249797] pci 0000:02:00.0: reg 0x18: [mem 0xfebff000-0xfebfffff 64bit]
Jan 21 09:35:31 am64 kernel: [    0.249813] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.249823] pci 0000:02:00.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
Jan 21 09:35:31 am64 kernel: [    0.249881] pci 0000:02:00.0: supports D1 D2
Jan 21 09:35:31 am64 kernel: [    0.249883] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jan 21 09:35:31 am64 kernel: [    0.257588] pci 0000:00:06.0: PCI bridge to [bus 02]
Jan 21 09:35:31 am64 kernel: [    0.257634] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Jan 21 09:35:31 am64 kernel: [    0.257637] pci 0000:00:06.0:   bridge window [mem 0xfeb00000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.257642] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.257771] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257816] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257819] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257821] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257823] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257826] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257828] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Jan 21 09:35:31 am64 kernel: [    0.257847] pci_bus 0000:00: on NUMA node 0
Jan 21 09:35:31 am64 kernel: [    0.259049] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.259475] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.259899] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.260323] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.260746] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.261169] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.261617] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.262011] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 21 09:35:31 am64 kernel: [    0.262794] ACPI: Enabled 1 GPEs in block 00 to 1F
Jan 21 09:35:31 am64 kernel: [    0.262896] ACPI: \_SB_.PCI0: notify handler is installed
Jan 21 09:35:31 am64 kernel: [    0.262962] Found 1 acpi root devices
Jan 21 09:35:31 am64 kernel: [    0.263341] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Jan 21 09:35:31 am64 kernel: [    0.263390] vgaarb: loaded
Jan 21 09:35:31 am64 kernel: [    0.263424] vgaarb: bridge control possible 0000:01:00.0
Jan 21 09:35:31 am64 kernel: [    0.263543] PCI: Using ACPI for IRQ routing
Jan 21 09:35:31 am64 kernel: [    0.272635] PCI: pci_cache_line_size set to 64 bytes
Jan 21 09:35:31 am64 kernel: [    0.272702] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
Jan 21 09:35:31 am64 kernel: [    0.272705] e820: reserve RAM buffer [mem 0xcffb0000-0xcfffffff]
Jan 21 09:35:31 am64 kernel: [    0.272900] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Jan 21 09:35:31 am64 kernel: [    0.273088] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Jan 21 09:35:31 am64 kernel: [    0.275228] Switched to clocksource hpet
Jan 21 09:35:31 am64 kernel: [    0.280038] pnp: PnP ACPI init
Jan 21 09:35:31 am64 kernel: [    0.280107] ACPI: bus type PNP registered
Jan 21 09:35:31 am64 kernel: [    0.280370] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 21 09:35:31 am64 kernel: [    0.280431] pnp 00:01: [dma 4]
Jan 21 09:35:31 am64 kernel: [    0.280466] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
Jan 21 09:35:31 am64 kernel: [    0.280521] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
Jan 21 09:35:31 am64 kernel: [    0.280559] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
Jan 21 09:35:31 am64 kernel: [    0.280604] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
Jan 21 09:35:31 am64 kernel: [    0.280972] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
Jan 21 09:35:31 am64 kernel: [    0.281068] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.281110] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281148] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 21 09:35:31 am64 kernel: [    0.281313] system 00:07: [io  0x04d0-0x04d1] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281354] system 00:07: [io  0x040b] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281390] system 00:07: [io  0x04d6] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281426] system 00:07: [io  0x0c00-0x0c01] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281465] system 00:07: [io  0x0c14] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281501] system 00:07: [io  0x0c50-0x0c51] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281537] system 00:07: [io  0x0c52] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281573] system 00:07: [io  0x0c6c] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281610] system 00:07: [io  0x0c6f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281646] system 00:07: [io  0x0cd0-0x0cd1] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281683] system 00:07: [io  0x0cd2-0x0cd3] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281721] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281758] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281795] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281832] system 00:07: [io  0x0800-0x089f] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.281868] system 00:07: [io  0x0b00-0x0b3f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281906] system 00:07: [io  0x0900-0x090f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281942] system 00:07: [io  0x0910-0x091f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.281979] system 00:07: [io  0xfe00-0xfefe] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.282016] system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.282053] system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.282092] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 21 09:35:31 am64 kernel: [    0.282165] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
Jan 21 09:35:31 am64 kernel: [    0.282254] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
Jan 21 09:35:31 am64 kernel: [    0.282839] pnp 00:0a: [dma 0 disabled]
Jan 21 09:35:31 am64 kernel: [    0.282916] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
Jan 21 09:35:31 am64 kernel: [    0.283136] system 00:0b: [io  0x0e00-0x0e0f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.283177] system 00:0b: [io  0x0e80-0x0e8f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.283232] system 00:0b: [io  0x0f40-0x0f4f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.283269] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.283307] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 21 09:35:31 am64 kernel: [    0.283390] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
Jan 21 09:35:31 am64 kernel: [    0.283432] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 21 09:35:31 am64 kernel: [    0.283618] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.283659] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.283696] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.283734] system 00:0d: [mem 0x00100000-0xcfffffff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.283771] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
Jan 21 09:35:31 am64 kernel: [    0.283809] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
Jan 21 09:35:31 am64 kernel: [    0.283947] pnp: PnP ACPI: found 14 devices
Jan 21 09:35:31 am64 kernel: [    0.283982] ACPI: bus type PNP unregistered
Jan 21 09:35:31 am64 kernel: [    0.297912] pci 0000:00:14.0: BAR 6: assigned [mem 0xf0000000-0xf00007ff pref]
Jan 21 09:35:31 am64 kernel: [    0.297959] pci 0000:00:02.0: PCI bridge to [bus 01]
Jan 21 09:35:31 am64 kernel: [    0.297996] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
Jan 21 09:35:31 am64 kernel: [    0.298035] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
Jan 21 09:35:31 am64 kernel: [    0.298073] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.298115] pci 0000:00:06.0: PCI bridge to [bus 02]
Jan 21 09:35:31 am64 kernel: [    0.298151] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Jan 21 09:35:31 am64 kernel: [    0.298189] pci 0000:00:06.0:   bridge window [mem 0xfeb00000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.298227] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.298269] pci 0000:00:14.4: PCI bridge to [bus 03]
Jan 21 09:35:31 am64 kernel: [    0.298316] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Jan 21 09:35:31 am64 kernel: [    0.298319] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Jan 21 09:35:31 am64 kernel: [    0.298321] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Jan 21 09:35:31 am64 kernel: [    0.298323] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
Jan 21 09:35:31 am64 kernel: [    0.298325] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
Jan 21 09:35:31 am64 kernel: [    0.298327] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.298329] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Jan 21 09:35:31 am64 kernel: [    0.298331] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
Jan 21 09:35:31 am64 kernel: [    0.298334] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.298336] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
Jan 21 09:35:31 am64 kernel: [    0.298338] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.298340] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 21 09:35:31 am64 kernel: [    0.298343] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
Jan 21 09:35:31 am64 kernel: [    0.298345] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
Jan 21 09:35:31 am64 kernel: [    0.298347] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
Jan 21 09:35:31 am64 kernel: [    0.298349] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
Jan 21 09:35:31 am64 kernel: [    0.298351] pci_bus 0000:03: resource 8 [mem 0xd0000000-0xdfffffff]
Jan 21 09:35:31 am64 kernel: [    0.298353] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
Jan 21 09:35:31 am64 kernel: [    0.298496] NET: Registered protocol family 2
Jan 21 09:35:31 am64 kernel: [    0.298943] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
Jan 21 09:35:31 am64 kernel: [    0.299181] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
Jan 21 09:35:31 am64 kernel: [    0.301539] TCP: Hash tables configured (established 65536 bind 65536)
Jan 21 09:35:31 am64 kernel: [    0.301663] TCP: reno registered
Jan 21 09:35:31 am64 kernel: [    0.301716] UDP hash table entries: 4096 (order: 7, 655360 bytes)
Jan 21 09:35:31 am64 kernel: [    0.302107] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
Jan 21 09:35:31 am64 kernel: [    0.302754] NET: Registered protocol family 1
Jan 21 09:35:31 am64 kernel: [    0.579190] pci 0000:01:00.0: Boot video device
Jan 21 09:35:31 am64 kernel: [    0.579201] PCI: CLS 64 bytes, default 64
Jan 21 09:35:31 am64 kernel: [    0.579319] Unpacking initramfs...
Jan 21 09:35:31 am64 kernel: [    0.871985] Freeing initrd memory: 13452K (ffff88022d2dc000 - ffff88022dfff000)
Jan 21 09:35:31 am64 kernel: [    0.872036] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Jan 21 09:35:31 am64 kernel: [    0.872073] software IO TLB [mem 0xcbfb0000-0xcffb0000] (64MB) mapped at [ffff8800cbfb0000-ffff8800cffaffff]
Jan 21 09:35:31 am64 kernel: [    0.872409] LVT offset 1 assigned for vector 0x400
Jan 21 09:35:31 am64 kernel: [    0.872459] IBS: LVT offset 1 assigned
Jan 21 09:35:31 am64 kernel: [    0.872548] perf: AMD IBS detected (0x0000001f)
Jan 21 09:35:31 am64 kernel: [    0.873175] audit: initializing netlink socket (disabled)
Jan 21 09:35:31 am64 kernel: [    0.873255] type=2000 audit(1390296888.768:1): initialized
Jan 21 09:35:31 am64 kernel: [    0.892834] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jan 21 09:35:31 am64 kernel: [    0.893996] VFS: Disk quotas dquot_6.5.2
Jan 21 09:35:31 am64 kernel: [    0.894085] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jan 21 09:35:31 am64 kernel: [    0.894321] msgmni has been set to 15960
Jan 21 09:35:31 am64 kernel: [    0.895671] alg: No test for stdrng (krng)
Jan 21 09:35:31 am64 kernel: [    0.895821] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Jan 21 09:35:31 am64 kernel: [    0.896149] io scheduler noop registered
Jan 21 09:35:31 am64 kernel: [    0.896191] io scheduler deadline registered
Jan 21 09:35:31 am64 kernel: [    0.896287] io scheduler cfq registered (default)
Jan 21 09:35:31 am64 kernel: [    0.896691] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [    0.896944] pcieport 0000:00:06.0: irq 41 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [    0.897031] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 21 09:35:31 am64 kernel: [    0.897120] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jan 21 09:35:31 am64 kernel: [    0.897248] GHES: HEST is not enabled!
Jan 21 09:35:31 am64 kernel: [    0.897466] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jan 21 09:35:31 am64 kernel: [    0.918045] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
Jan 21 09:35:31 am64 kernel: [    0.919366] Linux agpgart interface v0.103
Jan 21 09:35:31 am64 kernel: [    0.919811] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Jan 21 09:35:31 am64 kernel: [    0.920270] serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 21 09:35:31 am64 kernel: [    0.920322] serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 21 09:35:31 am64 kernel: [    0.920885] mousedev: PS/2 mouse device common for all mice
Jan 21 09:35:31 am64 kernel: [    0.921078] rtc_cmos 00:02: RTC can wake from S4
Jan 21 09:35:31 am64 kernel: [    0.921443] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Jan 21 09:35:31 am64 kernel: [    0.921519] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Jan 21 09:35:31 am64 kernel: [    0.921713] TCP: cubic registered
Jan 21 09:35:31 am64 kernel: [    0.921880] NET: Registered protocol family 10
Jan 21 09:35:31 am64 kernel: [    0.922296] mip6: Mobile IPv6
Jan 21 09:35:31 am64 kernel: [    0.922346] NET: Registered protocol family 17
Jan 21 09:35:31 am64 kernel: [    0.922403] mpls_gso: MPLS GSO support
Jan 21 09:35:31 am64 kernel: [    0.923412] registered taskstats version 1
Jan 21 09:35:31 am64 kernel: [    0.924658] rtc_cmos 00:02: setting system clock to 2014-01-21 09:34:49 UTC (1390296889)
Jan 21 09:35:31 am64 kernel: [    0.924769] PM: Hibernation image not present or could not be loaded.
Jan 21 09:35:31 am64 kernel: [    0.926177] Freeing unused kernel memory: 856K (ffffffff81aa2000 - ffffffff81b78000)
Jan 21 09:35:31 am64 kernel: [    0.926226] Write protecting the kernel read-only data: 10240k
Jan 21 09:35:31 am64 kernel: [    0.930768] Freeing unused kernel memory: 1400K (ffff88022e4a2000 - ffff88022e600000)
Jan 21 09:35:31 am64 kernel: [    0.936378] Freeing unused kernel memory: 1976K (ffff88022e812000 - ffff88022ea00000)
Jan 21 09:35:31 am64 kernel: [    0.947924] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Jan 21 09:35:31 am64 kernel: [    1.023786] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Jan 21 09:35:31 am64 kernel: [    1.023853] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
Jan 21 09:35:31 am64 kernel: [    1.024168] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [    1.024536] r8169 0000:02:00.0 eth0: RTL8168c/8111c at 0xffffc90000008000, 00:23:54:5e:5d:d5, XID 1c4000c0 IRQ 42
Jan 21 09:35:31 am64 kernel: [    1.024588] r8169 0000:02:00.0 eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
Jan 21 09:35:31 am64 kernel: [    1.029913] ACPI: bus type USB registered
Jan 21 09:35:31 am64 kernel: [    1.030075] usbcore: registered new interface driver usbfs
Jan 21 09:35:31 am64 kernel: [    1.031862] usbcore: registered new interface driver hub
Jan 21 09:35:31 am64 kernel: [    1.032372] SCSI subsystem initialized
Jan 21 09:35:31 am64 kernel: [    1.034509] libata version 3.00 loaded.
Jan 21 09:35:31 am64 kernel: [    1.034590] usbcore: registered new device driver usb
Jan 21 09:35:31 am64 kernel: [    1.035771] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 21 09:35:31 am64 kernel: [    1.036401] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jan 21 09:35:31 am64 kernel: [    1.036950] ohci-pci: OHCI PCI platform driver
Jan 21 09:35:31 am64 kernel: [    1.037151] ehci-pci: EHCI PCI platform driver
Jan 21 09:35:31 am64 kernel: [    1.037767] QUIRK: Enable AMD PLL fix
Jan 21 09:35:31 am64 kernel: [    1.037861] ohci-pci 0000:00:12.0: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.038011] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 1
Jan 21 09:35:31 am64 kernel: [    1.038146] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe9fe000
Jan 21 09:35:31 am64 kernel: [    1.054803] microcode: CPU0: patch_level=0x010000c8
Jan 21 09:35:31 am64 kernel: [    1.054978] microcode: CPU1: patch_level=0x010000c8
Jan 21 09:35:31 am64 kernel: [    1.055065] microcode: CPU2: patch_level=0x010000c8
Jan 21 09:35:31 am64 kernel: [    1.055136] microcode: CPU3: patch_level=0x010000c8
Jan 21 09:35:31 am64 kernel: [    1.055331] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jan 21 09:35:31 am64 kernel: [    1.094564] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Jan 21 09:35:31 am64 kernel: [    1.094614] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.094655] usb usb1: Product: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.094693] usb usb1: Manufacturer: Linux 3.13.0 ohci_hcd
Jan 21 09:35:31 am64 kernel: [    1.094731] usb usb1: SerialNumber: 0000:00:12.0
Jan 21 09:35:31 am64 kernel: [    1.095315] hub 1-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.095374] hub 1-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.096061] ohci-pci 0000:00:12.1: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.096106] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 2
Jan 21 09:35:31 am64 kernel: [    1.096172] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe9fd000
Jan 21 09:35:31 am64 kernel: [    1.154221] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Jan 21 09:35:31 am64 kernel: [    1.154275] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.154316] usb usb2: Product: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.154353] usb usb2: Manufacturer: Linux 3.13.0 ohci_hcd
Jan 21 09:35:31 am64 kernel: [    1.154390] usb usb2: SerialNumber: 0000:00:12.1
Jan 21 09:35:31 am64 kernel: [    1.154835] hub 2-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.154904] hub 2-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.155443] ohci-pci 0000:00:13.0: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.155490] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 3
Jan 21 09:35:31 am64 kernel: [    1.155571] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe9fc000
Jan 21 09:35:31 am64 kernel: [    1.214141] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Jan 21 09:35:31 am64 kernel: [    1.214189] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.214229] usb usb3: Product: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.214266] usb usb3: Manufacturer: Linux 3.13.0 ohci_hcd
Jan 21 09:35:31 am64 kernel: [    1.214303] usb usb3: SerialNumber: 0000:00:13.0
Jan 21 09:35:31 am64 kernel: [    1.214748] hub 3-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.214804] hub 3-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.215339] ohci-pci 0000:00:13.1: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.215385] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 4
Jan 21 09:35:31 am64 kernel: [    1.215449] ohci-pci 0000:00:13.1: irq 18, io mem 0xfe9fb000
Jan 21 09:35:31 am64 kernel: [    1.274068] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Jan 21 09:35:31 am64 kernel: [    1.274116] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.274156] usb usb4: Product: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.274193] usb usb4: Manufacturer: Linux 3.13.0 ohci_hcd
Jan 21 09:35:31 am64 kernel: [    1.274230] usb usb4: SerialNumber: 0000:00:13.1
Jan 21 09:35:31 am64 kernel: [    1.274687] hub 4-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.274761] hub 4-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.275299] ohci-pci 0000:00:14.5: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.275344] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 5
Jan 21 09:35:31 am64 kernel: [    1.275408] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe9f9000
Jan 21 09:35:31 am64 kernel: [    1.333982] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Jan 21 09:35:31 am64 kernel: [    1.334039] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.334080] usb usb5: Product: OHCI PCI host controller
Jan 21 09:35:31 am64 kernel: [    1.334117] usb usb5: Manufacturer: Linux 3.13.0 ohci_hcd
Jan 21 09:35:31 am64 kernel: [    1.334154] usb usb5: SerialNumber: 0000:00:14.5
Jan 21 09:35:31 am64 kernel: [    1.334592] hub 5-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.334649] hub 5-0:1.0: 2 ports detected
Jan 21 09:35:31 am64 kernel: [    1.489801] usb 2-1: new full-speed USB device number 2 using ohci-pci
Jan 21 09:35:31 am64 kernel: [    1.658318] usb 2-1: New USB device found, idVendor=0bc2, idProduct=2300
Jan 21 09:35:31 am64 kernel: [    1.658361] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jan 21 09:35:31 am64 kernel: [    1.658399] usb 2-1: Product: Portable        
Jan 21 09:35:31 am64 kernel: [    1.658435] usb 2-1: Manufacturer: Seagate 
Jan 21 09:35:31 am64 kernel: [    1.658470] usb 2-1: SerialNumber: 2GH5GFZD    
Jan 21 09:35:31 am64 kernel: [    1.660548] usb 2-1: USB disconnect, device number 2
Jan 21 09:35:31 am64 kernel: [    1.664092] ehci-pci 0000:00:12.2: EHCI Host Controller
Jan 21 09:35:31 am64 kernel: [    1.664182] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 6
Jan 21 09:35:31 am64 kernel: [    1.664250] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Jan 21 09:35:31 am64 kernel: [    1.664307] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Jan 21 09:35:31 am64 kernel: [    1.664390] ehci-pci 0000:00:12.2: debug port 1
Jan 21 09:35:31 am64 kernel: [    1.664591] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe9ff000
Jan 21 09:35:31 am64 kernel: [    1.665939] usbcore: registered new interface driver usb-storage
Jan 21 09:35:31 am64 kernel: [    1.793345] usb 3-1: new full-speed USB device number 2 using ohci-pci
Jan 21 09:35:31 am64 kernel: [    1.805353] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
Jan 21 09:35:31 am64 kernel: [    1.805569] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
Jan 21 09:35:31 am64 kernel: [    1.805628] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    1.805682] usb usb6: Product: EHCI Host Controller
Jan 21 09:35:31 am64 kernel: [    1.805729] usb usb6: Manufacturer: Linux 3.13.0 ehci_hcd
Jan 21 09:35:31 am64 kernel: [    1.805776] usb usb6: SerialNumber: 0000:00:12.2
Jan 21 09:35:31 am64 kernel: [    1.806347] hub 6-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.806423] hub 6-0:1.0: 6 ports detected
Jan 21 09:35:31 am64 kernel: [    1.869274] tsc: Refined TSC clocksource calibration: 3007.805 MHz
Jan 21 09:35:31 am64 kernel: [    1.869478] hub 1-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.869564] hub 1-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.933281] hub 2-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    1.933342] hub 2-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    1.966278] usb 3-1: not running at top speed; connect to a high speed hub
Jan 21 09:35:31 am64 kernel: [    1.981228] usb 3-1: New USB device found, idVendor=0bda, idProduct=2838
Jan 21 09:35:31 am64 kernel: [    1.981271] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan 21 09:35:31 am64 kernel: [    1.981308] usb 3-1: Product: RTL2838UHIDIR
Jan 21 09:35:31 am64 kernel: [    1.981343] usb 3-1: Manufacturer: Realtek
Jan 21 09:35:31 am64 kernel: [    1.993394] usb 3-1: USB disconnect, device number 2
Jan 21 09:35:31 am64 kernel: [    2.061293] ehci-pci 0000:00:13.2: EHCI Host Controller
Jan 21 09:35:31 am64 kernel: [    2.061348] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 7
Jan 21 09:35:31 am64 kernel: [    2.061395] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Jan 21 09:35:31 am64 kernel: [    2.061438] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Jan 21 09:35:31 am64 kernel: [    2.061498] ehci-pci 0000:00:13.2: debug port 1
Jan 21 09:35:31 am64 kernel: [    2.061607] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe9fa800
Jan 21 09:35:31 am64 kernel: [    2.072962] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jan 21 09:35:31 am64 kernel: [    2.073088] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
Jan 21 09:35:31 am64 kernel: [    2.073127] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 21 09:35:31 am64 kernel: [    2.073168] usb usb7: Product: EHCI Host Controller
Jan 21 09:35:31 am64 kernel: [    2.073205] usb usb7: Manufacturer: Linux 3.13.0 ehci_hcd
Jan 21 09:35:31 am64 kernel: [    2.073243] usb usb7: SerialNumber: 0000:00:13.2
Jan 21 09:35:31 am64 kernel: [    2.073682] hub 7-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    2.073745] hub 7-0:1.0: 6 ports detected
Jan 21 09:35:31 am64 kernel: [    2.136994] hub 3-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    2.137053] hub 3-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    2.200912] hub 4-0:1.0: USB hub found
Jan 21 09:35:31 am64 kernel: [    2.200970] hub 4-0:1.0: 3 ports detected
Jan 21 09:35:31 am64 kernel: [    2.205233] scsi0 : pata_atiixp
Jan 21 09:35:31 am64 kernel: [    2.205604] scsi1 : pata_atiixp
Jan 21 09:35:31 am64 kernel: [    2.205706] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jan 21 09:35:31 am64 kernel: [    2.205750] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jan 21 09:35:31 am64 kernel: [    2.205858] ahci 0000:00:11.0: version 3.0
Jan 21 09:35:31 am64 kernel: [    2.206551] ahci 0000:00:11.0: irq 43 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [    2.206765] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Jan 21 09:35:31 am64 kernel: [    2.206833] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Jan 21 09:35:31 am64 kernel: [    2.209722] scsi2 : ahci
Jan 21 09:35:31 am64 kernel: [    2.210101] scsi3 : ahci
Jan 21 09:35:31 am64 kernel: [    2.210473] scsi4 : ahci
Jan 21 09:35:31 am64 kernel: [    2.210849] scsi5 : ahci
Jan 21 09:35:31 am64 kernel: [    2.211221] scsi6 : ahci
Jan 21 09:35:31 am64 kernel: [    2.211597] scsi7 : ahci
Jan 21 09:35:31 am64 kernel: [    2.211777] ata3: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ff900 irq 43
Jan 21 09:35:31 am64 kernel: [    2.211824] ata4: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ff980 irq 43
Jan 21 09:35:31 am64 kernel: [    2.211866] ata5: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffa00 irq 43
Jan 21 09:35:31 am64 kernel: [    2.211908] ata6: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffa80 irq 43
Jan 21 09:35:31 am64 kernel: [    2.211950] ata7: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffb00 irq 43
Jan 21 09:35:31 am64 kernel: [    2.211991] ata8: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffb80 irq 43
Jan 21 09:35:31 am64 kernel: [    2.248883] usb 6-4: new high-speed USB device number 2 using ehci-pci
Jan 21 09:35:31 am64 kernel: [    2.394060] usb 6-4: New USB device found, idVendor=0bc2, idProduct=2300
Jan 21 09:35:31 am64 kernel: [    2.394104] usb 6-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jan 21 09:35:31 am64 kernel: [    2.394141] usb 6-4: Product: Portable        
Jan 21 09:35:31 am64 kernel: [    2.394177] usb 6-4: Manufacturer: Seagate 
Jan 21 09:35:31 am64 kernel: [    2.394212] usb 6-4: SerialNumber: 2GH5GFZD    
Jan 21 09:35:31 am64 kernel: [    2.395380] usb-storage 6-4:1.0: USB Mass Storage device detected
Jan 21 09:35:31 am64 kernel: [    2.395678] usb-storage 6-4:1.0: Quirks match for vid 0bc2 pid 2300: 200000
Jan 21 09:35:31 am64 kernel: [    2.395958] scsi8 : usb-storage 6-4:1.0
Jan 21 09:35:31 am64 kernel: [    2.508499] usb 7-1: new high-speed USB device number 2 using ehci-pci
Jan 21 09:35:31 am64 kernel: [    2.528421] ata5: SATA link down (SStatus 0 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.532372] ata6: SATA link down (SStatus 0 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.536378] ata8: SATA link down (SStatus 0 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.536601] ata7: SATA link down (SStatus 0 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.650632] usb 7-1: New USB device found, idVendor=0bda, idProduct=2838
Jan 21 09:35:31 am64 kernel: [    2.650675] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan 21 09:35:31 am64 kernel: [    2.650712] usb 7-1: Product: RTL2838UHIDIR
Jan 21 09:35:31 am64 kernel: [    2.650747] usb 7-1: Manufacturer: Realtek
Jan 21 09:35:31 am64 kernel: [    2.700169] ata3: softreset failed (device not ready)
Jan 21 09:35:31 am64 kernel: [    2.700221] ata3: applying PMP SRST workaround and retrying
Jan 21 09:35:31 am64 kernel: [    2.700330] ata4: softreset failed (device not ready)
Jan 21 09:35:31 am64 kernel: [    2.700878] ata4: applying PMP SRST workaround and retrying
Jan 21 09:35:31 am64 kernel: [    2.868387] Switched to clocksource tsc
Jan 21 09:35:31 am64 kernel: [    2.871941] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.873213] ata4.00: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
Jan 21 09:35:31 am64 kernel: [    2.874682] ata4.00: configured for UDMA/100
Jan 21 09:35:31 am64 kernel: [    2.875906] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 21 09:35:31 am64 kernel: [    2.877115] ata3.00: ATA-8: ST3500418AS, CC49, max UDMA/133
Jan 21 09:35:31 am64 kernel: [    2.877157] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
Jan 21 09:35:31 am64 kernel: [    2.878581] ata3.00: configured for UDMA/133
Jan 21 09:35:31 am64 kernel: [    2.879735] scsi 2:0:0:0: Direct-Access     ATA      ST3500418AS      CC49 PQ: 0 ANSI: 5
Jan 21 09:35:31 am64 kernel: [    2.882070] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 PQ: 0 ANSI: 5
Jan 21 09:35:31 am64 kernel: [    2.898724] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 21 09:35:31 am64 kernel: [    2.898775] cdrom: Uniform CD-ROM driver Revision: 3.20
Jan 21 09:35:31 am64 kernel: [    2.899328] sr 3:0:0:0: Attached scsi CD-ROM sr0
Jan 21 09:35:31 am64 kernel: [    2.904107] sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Jan 21 09:35:31 am64 kernel: [    2.904597] sd 2:0:0:0: [sda] Write Protect is off
Jan 21 09:35:31 am64 kernel: [    2.904664] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 21 09:35:31 am64 kernel: [    2.904860] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 21 09:35:31 am64 kernel: [    2.905744] sd 2:0:0:0: Attached scsi generic sg0 type 0
Jan 21 09:35:31 am64 kernel: [    2.905979] sr 3:0:0:0: Attached scsi generic sg1 type 5
Jan 21 09:35:31 am64 kernel: [    2.957971]  sda: sda1 sda2 sda3 sda4 sda5
Jan 21 09:35:31 am64 kernel: [    2.959688] sd 2:0:0:0: [sda] Attached SCSI disk
Jan 21 09:35:31 am64 kernel: [    3.392357] scsi 8:0:0:0: Direct-Access     Seagate  Portable         0130 PQ: 0 ANSI: 4
Jan 21 09:35:31 am64 kernel: [    3.393322] sd 8:0:0:0: Attached scsi generic sg2 type 0
Jan 21 09:35:31 am64 kernel: [    3.394236] sd 8:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 21 09:35:31 am64 kernel: [    3.395100] sd 8:0:0:0: [sdb] Write Protect is off
Jan 21 09:35:31 am64 kernel: [    3.395171] sd 8:0:0:0: [sdb] Mode Sense: 2f 08 00 00
Jan 21 09:35:31 am64 kernel: [    3.395969] sd 8:0:0:0: [sdb] No Caching mode page found
Jan 21 09:35:31 am64 kernel: [    3.396015] sd 8:0:0:0: [sdb] Assuming drive cache: write back
Jan 21 09:35:31 am64 kernel: [    3.399595] sd 8:0:0:0: [sdb] No Caching mode page found
Jan 21 09:35:31 am64 kernel: [    3.399657] sd 8:0:0:0: [sdb] Assuming drive cache: write back
Jan 21 09:35:31 am64 kernel: [    3.420148]  sdb: sdb1 sdb2
Jan 21 09:35:31 am64 kernel: [    3.423986] sd 8:0:0:0: [sdb] No Caching mode page found
Jan 21 09:35:31 am64 kernel: [    3.424035] sd 8:0:0:0: [sdb] Assuming drive cache: write back
Jan 21 09:35:31 am64 kernel: [    3.424076] sd 8:0:0:0: [sdb] Attached SCSI disk
Jan 21 09:35:31 am64 kernel: [    3.880369] PM: Starting manual resume from disk
Jan 21 09:35:31 am64 kernel: [    3.880417] PM: Hibernation image partition 8:4 present
Jan 21 09:35:31 am64 kernel: [    3.880419] PM: Looking for hibernation image.
Jan 21 09:35:31 am64 kernel: [    3.885544] PM: Image not found (code -22)
Jan 21 09:35:31 am64 kernel: [    3.885549] PM: Hibernation image not present or could not be loaded.
Jan 21 09:35:31 am64 kernel: [    3.926337] EXT4-fs (sda3): mounting ext3 file system using the ext4 subsystem
Jan 21 09:35:31 am64 kernel: [    3.970931] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
Jan 21 09:35:31 am64 kernel: [    4.032141] random: nonblocking pool is initialized
Jan 21 09:35:31 am64 kernel: [    8.830492] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
Jan 21 09:35:31 am64 kernel: [    8.830548] ACPI: Power Button [PWRB]
Jan 21 09:35:31 am64 kernel: [    8.830656] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Jan 21 09:35:31 am64 kernel: [    8.830699] ACPI: Power Button [PWRF]
Jan 21 09:35:31 am64 kernel: [    9.404228] ACPI: processor limited to max C-state 1
Jan 21 09:35:31 am64 kernel: [    9.457836] acpi-cpufreq: overriding BIOS provided _PSD data
Jan 21 09:35:31 am64 kernel: [    9.481035] input: PC Speaker as /devices/platform/pcspkr/input/input4
Jan 21 09:35:31 am64 kernel: [    9.526851] wmi: Mapper loaded
Jan 21 09:35:31 am64 kernel: [    9.802211] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \SOR1 1 (20131115/utaddress-251)
Jan 21 09:35:31 am64 kernel: [    9.802357] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jan 21 09:35:31 am64 kernel: [    9.946585] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
Jan 21 09:35:31 am64 kernel: [    9.946913] sp5100_tco: PCI Revision ID: 0x3a
Jan 21 09:35:31 am64 kernel: [    9.946988] sp5100_tco: failed to find MMIO address, giving up.
Jan 21 09:35:31 am64 kernel: [   10.230604] [drm] Initialized drm 1.1.0 20060810
Jan 21 09:35:31 am64 kernel: [   10.573122] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
Jan 21 09:35:31 am64 kernel: [   10.690736] kvm: Nested Virtualization enabled
Jan 21 09:35:31 am64 kernel: [   10.690803] kvm: Nested Paging enabled
Jan 21 09:35:31 am64 kernel: [   11.049383] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
Jan 21 09:35:31 am64 kernel: [   11.491324] [drm] radeon kernel modesetting enabled.
Jan 21 09:35:31 am64 kernel: [   11.492881] [drm] initializing kernel modesetting (RV670 0x1002:0x9505 0x1462:0x1121).
Jan 21 09:35:31 am64 kernel: [   11.492995] [drm] register mmio base: 0xFEAF0000
Jan 21 09:35:31 am64 kernel: [   11.493046] [drm] register mmio size: 65536
Jan 21 09:35:31 am64 kernel: [   11.494184] ATOM BIOS: 113
Jan 21 09:35:31 am64 kernel: [   11.494277] radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
Jan 21 09:35:31 am64 kernel: [   11.494339] radeon 0000:01:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
Jan 21 09:35:31 am64 kernel: [   11.494392] [drm] Detected VRAM RAM=512M, BAR=256M
Jan 21 09:35:31 am64 kernel: [   11.494437] [drm] RAM width 256bits DDR
Jan 21 09:35:31 am64 kernel: [   11.494872] [TTM] Zone  kernel: Available graphics memory: 4087912 kiB
Jan 21 09:35:31 am64 kernel: [   11.494930] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
Jan 21 09:35:31 am64 kernel: [   11.494977] [TTM] Initializing pool allocator
Jan 21 09:35:31 am64 kernel: [   11.495042] [TTM] Initializing DMA pool allocator
Jan 21 09:35:31 am64 kernel: [   11.495667] [drm] radeon: 512M of VRAM memory ready
Jan 21 09:35:31 am64 kernel: [   11.495719] [drm] radeon: 512M of GTT memory ready.
Jan 21 09:35:31 am64 kernel: [   11.495851] [drm] GART: num cpu pages 131072, num gpu pages 131072
Jan 21 09:35:31 am64 kernel: [   11.497486] [drm] PCIE gen 2 link speeds already enabled
Jan 21 09:35:31 am64 kernel: [   11.507922] [drm] Loading RV670 Microcode
Jan 21 09:35:31 am64 kernel: [   11.700475] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
Jan 21 09:35:31 am64 kernel: [   11.713926] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input14
Jan 21 09:35:31 am64 kernel: [   11.714202] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input13
Jan 21 09:35:31 am64 kernel: [   11.714480] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
Jan 21 09:35:31 am64 kernel: [   11.714763] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
Jan 21 09:35:31 am64 kernel: [   11.715041] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
Jan 21 09:35:31 am64 kernel: [   11.715321] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
Jan 21 09:35:31 am64 kernel: [   11.715591] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
Jan 21 09:35:31 am64 kernel: [   11.715871] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
Jan 21 09:35:31 am64 kernel: [   11.883404] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
Jan 21 09:35:31 am64 kernel: [   11.883689] radeon 0000:01:00.0: WB enabled
Jan 21 09:35:31 am64 kernel: [   11.883733] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff88022d64ec00
Jan 21 09:35:31 am64 kernel: [   11.883777] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff88022d64ec0c
Jan 21 09:35:31 am64 kernel: [   11.883823] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Jan 21 09:35:31 am64 kernel: [   11.883860] [drm] Driver supports precise vblank timestamp query.
Jan 21 09:35:31 am64 kernel: [   11.883926] radeon 0000:01:00.0: irq 44 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [   11.883974] radeon 0000:01:00.0: radeon: using MSI.
Jan 21 09:35:31 am64 kernel: [   11.884182] [drm] radeon: irq initialized.
Jan 21 09:35:31 am64 kernel: [   11.916862] [drm] ring test on 0 succeeded in 1 usecs
Jan 21 09:35:31 am64 kernel: [   11.916968] [drm] ring test on 3 succeeded in 1 usecs
Jan 21 09:35:31 am64 kernel: [   11.917615] [drm] Enabling audio 0 support
Jan 21 09:35:31 am64 kernel: [   11.917824] [drm] ib test on ring 0 succeeded in 0 usecs
Jan 21 09:35:31 am64 kernel: [   11.917879] [drm] ib test on ring 3 succeeded in 0 usecs
Jan 21 09:35:31 am64 kernel: [   11.918514] [drm] Radeon Display Connectors
Jan 21 09:35:31 am64 kernel: [   11.918557] [drm] Connector 0:
Jan 21 09:35:31 am64 kernel: [   11.918592] [drm]   DVI-I-1
Jan 21 09:35:31 am64 kernel: [   11.918628] [drm]   HPD1
Jan 21 09:35:31 am64 kernel: [   11.918664] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Jan 21 09:35:31 am64 kernel: [   11.918704] [drm]   Encoders:
Jan 21 09:35:31 am64 kernel: [   11.918739] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
Jan 21 09:35:31 am64 kernel: [   11.918776] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
Jan 21 09:35:31 am64 kernel: [   11.918812] [drm] Connector 1:
Jan 21 09:35:31 am64 kernel: [   11.918848] [drm]   DIN-1
Jan 21 09:35:31 am64 kernel: [   11.918883] [drm]   Encoders:
Jan 21 09:35:31 am64 kernel: [   11.918918] [drm]     TV1: INTERNAL_KLDSCP_DAC2
Jan 21 09:35:31 am64 kernel: [   11.918954] [drm] Connector 2:
Jan 21 09:35:31 am64 kernel: [   11.918989] [drm]   DVI-I-2
Jan 21 09:35:31 am64 kernel: [   11.919024] [drm]   HPD2
Jan 21 09:35:31 am64 kernel: [   11.919060] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Jan 21 09:35:31 am64 kernel: [   11.919100] [drm]   Encoders:
Jan 21 09:35:31 am64 kernel: [   11.919135] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Jan 21 09:35:31 am64 kernel: [   11.919172] [drm]     DFP2: INTERNAL_LVTM1
Jan 21 09:35:31 am64 kernel: [   11.919217] [drm] Internal thermal controller with fan control
Jan 21 09:35:31 am64 kernel: [   11.919320] [drm] radeon: power management initialized
Jan 21 09:35:31 am64 kernel: [   11.944676] usb 7-1: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
Jan 21 09:35:31 am64 kernel: [   11.976375] [drm] fb mappable at 0xD0141000
Jan 21 09:35:31 am64 kernel: [   11.976416] [drm] vram apper at 0xD0000000
Jan 21 09:35:31 am64 kernel: [   11.976450] [drm] size 8294400
Jan 21 09:35:31 am64 kernel: [   11.976483] [drm] fb depth is 24
Jan 21 09:35:31 am64 kernel: [   11.976517] [drm]    pitch is 7680
Jan 21 09:35:31 am64 kernel: [   11.976768] fbcon: radeondrmfb (fb0) is primary device
Jan 21 09:35:31 am64 kernel: [   11.983968] usb 7-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Jan 21 09:35:31 am64 kernel: [   11.984074] DVB: registering new adapter (Realtek RTL2832U reference design)
Jan 21 09:35:31 am64 kernel: [   12.113854] usb 7-1: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
Jan 21 09:35:31 am64 kernel: [   12.171068] i2c i2c-5: fc0012: Fitipower FC0012 successfully identified
Jan 21 09:35:31 am64 kernel: [   12.182385] Registered IR keymap rc-empty
Jan 21 09:35:31 am64 kernel: [   12.182683] input: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:13.2/usb7/7-1/rc/rc0/input15
Jan 21 09:35:31 am64 kernel: [   12.182828] rc0: Realtek RTL2832U reference design as /devices/pci0000:00/0000:00:13.2/usb7/7-1/rc/rc0
Jan 21 09:35:31 am64 kernel: [   12.202916] Console: switching to colour frame buffer device 240x67
Jan 21 09:35:31 am64 kernel: [   12.203015] usb 7-1: dvb_usb_v2: schedule remote query interval to 400 msecs
Jan 21 09:35:31 am64 kernel: [   12.210390] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
Jan 21 09:35:31 am64 kernel: [   12.210425] radeon 0000:01:00.0: registered panic notifier
Jan 21 09:35:31 am64 kernel: [   12.210461] [drm] Initialized radeon 2.36.0 20080528 for 0000:01:00.0 on minor 0
Jan 21 09:35:31 am64 kernel: [   12.210728] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
Jan 21 09:35:31 am64 kernel: [   12.210869] snd_hda_intel 0000:01:00.1: irq 45 for MSI/MSI-X
Jan 21 09:35:31 am64 kernel: [   12.215393] usb 7-1: dvb_usb_v2: 'Realtek RTL2832U reference design' successfully initialized and connected
Jan 21 09:35:31 am64 kernel: [   12.215701] usbcore: registered new interface driver dvb_usb_rtl28xxu
Jan 21 09:35:31 am64 kernel: [   12.274019] IR NEC protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.339903] IR Sony protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.339962] IR RC5(x) protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.340521] lirc_dev: IR Remote Control driver registered, major 251 
Jan 21 09:35:31 am64 kernel: [   12.341453] IR RC6 protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.341513] IR SANYO protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.341978] IR JVC protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.356296] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as /devices/virtual/input/input16
Jan 21 09:35:31 am64 kernel: [   12.356897] IR MCE Keyboard/mouse protocol handler initialized
Jan 21 09:35:31 am64 kernel: [   12.358716] rc rc0: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 0
Jan 21 09:35:31 am64 kernel: [   12.358901] IR LIRC bridge handler initialized
Jan 21 09:35:31 am64 kernel: [   12.438276] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input17
Jan 21 09:35:31 am64 kernel: [   16.074032] Adding 4194288k swap on /dev/sda4.  Priority:-1 extents:1 across:4194288k 
Jan 21 09:35:31 am64 kernel: [   16.158165] EXT4-fs (sda3): re-mounted. Opts: (null)
Jan 21 09:35:31 am64 kernel: [   17.012539] EXT4-fs (sda3): re-mounted. Opts: data=ordered,errors=remount-ro
Jan 21 09:35:31 am64 kernel: [   17.842626] fuse init (API version 7.22)
Jan 21 09:35:31 am64 kernel: [   33.074458] EXT4-fs (sda2): mounting ext3 file system using the ext4 subsystem
Jan 21 09:35:31 am64 kernel: [   33.088897] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
Jan 21 09:35:31 am64 kernel: [   33.229479] EXT4-fs (sdb2): mounting ext3 file system using the ext4 subsystem
Jan 21 09:35:31 am64 kernel: [   33.301632] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
Jan 21 09:35:31 am64 kernel: [   36.233335] r8169 0000:02:00.0 eth0: link down
Jan 21 09:35:31 am64 kernel: [   36.240266] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Jan 21 09:35:31 am64 kernel: [   39.348109] r8169 0000:02:00.0 eth0: link up
Jan 21 09:35:31 am64 kernel: [   39.355008] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Jan 21 09:35:32 am64 kernel: [   43.552745] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input18
Jan 21 09:35:34 am64 kernel: [   45.396506] lp: driver loaded but no devices found
Jan 21 09:35:34 am64 kernel: [   45.559544] ppdev: user-space parallel port driver
Jan 21 09:36:02 am64 kernel: [   74.231629] nfc: nfc_init: NFC Core ver 0.1
Jan 21 09:36:02 am64 kernel: [   74.232095] NET: Registered protocol family 39
Jan 21 09:36:05 am64 kernel: [   76.327008] Bluetooth: Core ver 2.17
Jan 21 09:36:05 am64 kernel: [   76.327067] NET: Registered protocol family 31
Jan 21 09:36:05 am64 kernel: [   76.327070] Bluetooth: HCI device and connection manager initialized
Jan 21 09:36:05 am64 kernel: [   76.327211] Bluetooth: HCI socket layer initialized
Jan 21 09:36:05 am64 kernel: [   76.327216] Bluetooth: L2CAP socket layer initialized
Jan 21 09:36:05 am64 kernel: [   76.327226] Bluetooth: SCO socket layer initialized
Jan 21 09:36:05 am64 kernel: [   76.511210] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Jan 21 09:36:05 am64 kernel: [   76.511218] Bluetooth: BNEP filters: protocol multicast
Jan 21 09:36:05 am64 kernel: [   76.511233] Bluetooth: BNEP socket layer initialized
Jan 21 09:36:27 am64 kernel: [   98.271247] FS-Cache: Loaded
Jan 21 09:36:27 am64 kernel: [   98.280138] Key type dns_resolver registered
Jan 21 09:36:27 am64 kernel: [   98.371933] FS-Cache: Netfs 'cifs' registered for caching
Jan 21 09:36:27 am64 kernel: [   98.372192] Key type cifs.spnego registered
Jan 21 09:36:27 am64 kernel: [   98.372304] Key type cifs.idmap registered
Jan 21 09:39:37 am64 kernel: [  287.979279] Bluetooth: RFCOMM TTY layer initialized
Jan 21 09:39:37 am64 kernel: [  287.979330] Bluetooth: RFCOMM socket layer initialized
Jan 21 09:39:37 am64 kernel: [  287.979365] Bluetooth: RFCOMM ver 1.11
Jan 21 09:39:38 am64 kernel: [  288.550832] ip_tables: (C) 2000-2006 Netfilter Core Team
Jan 21 09:40:49 am64 kernel: [  360.256826] INFO: task kworker/u12:7:185 blocked for more than 120 seconds.
Jan 21 09:40:49 am64 kernel: [  360.256983]       Not tainted 3.13.0 #633
Jan 21 09:40:49 am64 kernel: [  360.257065] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:40:49 am64 kernel: [  360.257217] kworker/u12:7   D ffff880222d2f010     0   185      2 0x00000000
Jan 21 09:40:49 am64 kernel: [  360.257391] Workqueue: hd-audio1 hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.257523]  ffff8800cb115af0 0000000000000046 ffff88022dad2010 ffff8800cb115fd8
Jan 21 09:40:49 am64 kernel: [  360.257708]  0000000000013880 0000000000013880 ffff88022dad2010 ffff880220a88000
Jan 21 09:40:49 am64 kernel: [  360.257877]  ffff88022dad2010 ffff880220a88330 ffff880220a88328 0000000000000246
Jan 21 09:40:49 am64 kernel: [  360.258046] Call Trace:
Jan 21 09:40:49 am64 kernel: [  360.258111]  [<ffffffff814920c4>] schedule_preempt_disabled+0x24/0x70
Jan 21 09:40:49 am64 kernel: [  360.258242]  [<ffffffff81493083>] mutex_lock_nested+0x143/0x330
Jan 21 09:40:49 am64 kernel: [  360.258367]  [<ffffffffa05ea741>] ? hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.258547]  [<ffffffffa03f8280>] ? jack_detect_update+0x90/0xd0 [snd_hda_codec]
Jan 21 09:40:49 am64 kernel: [  360.258697]  [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.258850]  [<ffffffff81493fc9>] ? mutex_unlock+0x9/0x10
Jan 21 09:40:49 am64 kernel: [  360.258963]  [<ffffffffa05eab81>] generic_hdmi_resume+0x51/0x60 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.259129]  [<ffffffffa03f3560>] hda_call_codec_resume+0x160/0x1c0 [snd_hda_codec]
Jan 21 09:40:49 am64 kernel: [  360.259293]  [<ffffffffa03f37cc>] snd_hda_power_save+0x20c/0x2a0 [snd_hda_codec]
Jan 21 09:40:49 am64 kernel: [  360.259452]  [<ffffffffa03f38bf>] codec_exec_verb+0x5f/0x210 [snd_hda_codec]
Jan 21 09:40:49 am64 kernel: [  360.259606]  [<ffffffffa03f25fa>] snd_hda_codec_read+0x5a/0x90 [snd_hda_codec]
Jan 21 09:40:49 am64 kernel: [  360.259754]  [<ffffffffa05ecdd4>] snd_hdmi_get_eld_ati+0x34/0x43a [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.259913]  [<ffffffffa05e9a6c>] atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.260067]  [<ffffffffa05ea782>] hdmi_present_sense+0x92/0x360 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.260222]  [<ffffffffa05eaa77>] hdmi_repoll_eld+0x27/0x50 [snd_hda_codec_hdmi]
Jan 21 09:40:49 am64 kernel: [  360.260370]  [<ffffffff8105c958>] process_one_work+0x1f8/0x500
Jan 21 09:40:49 am64 kernel: [  360.260487]  [<ffffffff8105c8ed>] ? process_one_work+0x18d/0x500
Jan 21 09:40:49 am64 kernel: [  360.265971]  [<ffffffff8105d638>] worker_thread+0x118/0x390
Jan 21 09:40:49 am64 kernel: [  360.271395]  [<ffffffff8105d520>] ? manage_workers.isra.27+0x2a0/0x2a0
Jan 21 09:40:49 am64 kernel: [  360.276844]  [<ffffffff81063687>] kthread+0xf7/0x110
Jan 21 09:40:49 am64 kernel: [  360.282292]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:40:49 am64 kernel: [  360.287786]  [<ffffffff8149e58c>] ret_from_fork+0x7c/0xb0
Jan 21 09:40:50 am64 kernel: [  360.293249]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:40:50 am64 kernel: [  360.298715] 4 locks held by kworker/u12:7/185:
Jan 21 09:40:50 am64 kernel: [  360.304154]  #0:  (%s#3){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:40:50 am64 kernel: [  360.309788]  #1:  ((&(&per_pin->work)->work)){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:40:50 am64 kernel: [  360.315547]  #2:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:40:50 am64 kernel: [  360.321442]  #3:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.105578] INFO: task kworker/u12:7:185 blocked for more than 120 seconds.
Jan 21 09:42:50 am64 kernel: [  480.111602]       Not tainted 3.13.0 #633
Jan 21 09:42:50 am64 kernel: [  480.117530] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:42:50 am64 kernel: [  480.123570] kworker/u12:7   D ffff880222d2f010     0   185      2 0x00000000
Jan 21 09:42:50 am64 kernel: [  480.129667] Workqueue: hd-audio1 hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.135782]  ffff8800cb115af0 0000000000000046 ffff88022dad2010 ffff8800cb115fd8
Jan 21 09:42:50 am64 kernel: [  480.142006]  0000000000013880 0000000000013880 ffff88022dad2010 ffff880220a88000
Jan 21 09:42:50 am64 kernel: [  480.148205]  ffff88022dad2010 ffff880220a88330 ffff880220a88328 0000000000000246
Jan 21 09:42:50 am64 kernel: [  480.154396] Call Trace:
Jan 21 09:42:50 am64 kernel: [  480.160502]  [<ffffffff814920c4>] schedule_preempt_disabled+0x24/0x70
Jan 21 09:42:50 am64 kernel: [  480.166707]  [<ffffffff81493083>] mutex_lock_nested+0x143/0x330
Jan 21 09:42:50 am64 kernel: [  480.172913]  [<ffffffffa05ea741>] ? hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.179207]  [<ffffffffa03f8280>] ? jack_detect_update+0x90/0xd0 [snd_hda_codec]
Jan 21 09:42:50 am64 kernel: [  480.185492]  [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.191810]  [<ffffffff81493fc9>] ? mutex_unlock+0x9/0x10
Jan 21 09:42:50 am64 kernel: [  480.198127]  [<ffffffffa05eab81>] generic_hdmi_resume+0x51/0x60 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.204506]  [<ffffffffa03f3560>] hda_call_codec_resume+0x160/0x1c0 [snd_hda_codec]
Jan 21 09:42:50 am64 kernel: [  480.210895]  [<ffffffffa03f37cc>] snd_hda_power_save+0x20c/0x2a0 [snd_hda_codec]
Jan 21 09:42:50 am64 kernel: [  480.217300]  [<ffffffffa03f38bf>] codec_exec_verb+0x5f/0x210 [snd_hda_codec]
Jan 21 09:42:50 am64 kernel: [  480.223738]  [<ffffffffa03f25fa>] snd_hda_codec_read+0x5a/0x90 [snd_hda_codec]
Jan 21 09:42:50 am64 kernel: [  480.230218]  [<ffffffffa05ecdd4>] snd_hdmi_get_eld_ati+0x34/0x43a [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.236684]  [<ffffffffa05e9a6c>] atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.243121]  [<ffffffffa05ea782>] hdmi_present_sense+0x92/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.249510]  [<ffffffffa05eaa77>] hdmi_repoll_eld+0x27/0x50 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.255917]  [<ffffffff8105c958>] process_one_work+0x1f8/0x500
Jan 21 09:42:50 am64 kernel: [  480.262343]  [<ffffffff8105c8ed>] ? process_one_work+0x18d/0x500
Jan 21 09:42:50 am64 kernel: [  480.268799]  [<ffffffff8105d638>] worker_thread+0x118/0x390
Jan 21 09:42:50 am64 kernel: [  480.275272]  [<ffffffff8105d520>] ? manage_workers.isra.27+0x2a0/0x2a0
Jan 21 09:42:50 am64 kernel: [  480.281784]  [<ffffffff81063687>] kthread+0xf7/0x110
Jan 21 09:42:50 am64 kernel: [  480.288195]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:42:50 am64 kernel: [  480.294551]  [<ffffffff8149e58c>] ret_from_fork+0x7c/0xb0
Jan 21 09:42:50 am64 kernel: [  480.300839]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:42:50 am64 kernel: [  480.307108] 4 locks held by kworker/u12:7/185:
Jan 21 09:42:50 am64 kernel: [  480.313328]  #0:  (%s#3){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:42:50 am64 kernel: [  480.319672]  #1:  ((&(&per_pin->work)->work)){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:42:50 am64 kernel: [  480.326145]  #2:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.332717]  #3:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.339232] INFO: task pulseaudio:4305 blocked for more than 120 seconds.
Jan 21 09:42:50 am64 kernel: [  480.345668]       Not tainted 3.13.0 #633
Jan 21 09:42:50 am64 kernel: [  480.352073] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:42:50 am64 kernel: [  480.358566] pulseaudio      D ffffffff81a114c0     0  4305      1 0x00000000
Jan 21 09:42:50 am64 kernel: [  480.365100]  ffff8800bd1f5d88 0000000000000046 ffff8800bf6ce010 ffff8800bd1f5fd8
Jan 21 09:42:50 am64 kernel: [  480.371665]  0000000000013880 0000000000013880 ffff8800bf6ce010 ffff8800bf6ce010
Jan 21 09:42:50 am64 kernel: [  480.378187]  ffff88022173f198 ffff88022173f1a0 ffffffff00000000 ffff88022173f1d8
Jan 21 09:42:50 am64 kernel: [  480.384703] Call Trace:
Jan 21 09:42:50 am64 kernel: [  480.391130]  [<ffffffff81491c44>] schedule+0x24/0x70
Jan 21 09:42:50 am64 kernel: [  480.397584]  [<ffffffff8149571d>] rwsem_down_write_failed+0xfd/0x1c0
Jan 21 09:42:50 am64 kernel: [  480.404053]  [<ffffffff81268ae3>] call_rwsem_down_write_failed+0x13/0x20
Jan 21 09:42:50 am64 kernel: [  480.410521]  [<ffffffff814950ac>] ? down_write+0x4c/0x60
Jan 21 09:42:50 am64 kernel: [  480.416979]  [<ffffffffa024c528>] ? snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:42:50 am64 kernel: [  480.423421]  [<ffffffffa024c528>] snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:42:50 am64 kernel: [  480.429847]  [<ffffffff811610e2>] __fput+0xe2/0x230
Jan 21 09:42:50 am64 kernel: [  480.436234]  [<ffffffff81161269>] ____fput+0x9/0x10
Jan 21 09:42:50 am64 kernel: [  480.442575]  [<ffffffff8106064f>] task_work_run+0x8f/0xd0
Jan 21 09:42:50 am64 kernel: [  480.448920]  [<ffffffff810028c9>] do_notify_resume+0x69/0xa0
Jan 21 09:42:50 am64 kernel: [  480.455259]  [<ffffffff8149e940>] int_signal+0x12/0x17
Jan 21 09:42:50 am64 kernel: [  480.461580] 1 lock held by pulseaudio/4305:
Jan 21 09:42:50 am64 kernel: [  480.467879]  #0:  (&card->controls_rwsem){......}, at: [<ffffffffa024c528>] snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:42:50 am64 kernel: [  480.474423] INFO: task alsactl:4728 blocked for more than 120 seconds.
Jan 21 09:42:50 am64 kernel: [  480.480933]       Not tainted 3.13.0 #633
Jan 21 09:42:50 am64 kernel: [  480.487414] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:42:50 am64 kernel: [  480.493986] alsactl         D ffff88022d62b010     0  4728   4722 0x00000000
Jan 21 09:42:50 am64 kernel: [  480.500551]  ffff8800bd13bc30 0000000000000046 ffff8802212c4010 ffff8800bd13bfd8
Jan 21 09:42:50 am64 kernel: [  480.507111]  0000000000013880 0000000000013880 ffff8802212c4010 ffff880220a88000
Jan 21 09:42:50 am64 kernel: [  480.513548]  ffff8802212c4010 ffff880220a88330 ffff880220a88328 0000000000000246
Jan 21 09:42:50 am64 kernel: [  480.520064] Call Trace:
Jan 21 09:42:50 am64 kernel: [  480.526403]  [<ffffffff814920c4>] schedule_preempt_disabled+0x24/0x70
Jan 21 09:42:50 am64 kernel: [  480.532803]  [<ffffffff81493083>] mutex_lock_nested+0x143/0x330
Jan 21 09:42:50 am64 kernel: [  480.539159]  [<ffffffffa05e8ee8>] ? hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.545524]  [<ffffffffa05e8ee8>] hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]
Jan 21 09:42:50 am64 kernel: [  480.551864]  [<ffffffffa024c681>] snd_ctl_elem_info_user+0xb1/0x280 [snd]
Jan 21 09:42:50 am64 kernel: [  480.558167]  [<ffffffffa024e93f>] snd_ctl_ioctl+0x7bf/0xbc0 [snd]
Jan 21 09:42:50 am64 kernel: [  480.564396]  [<ffffffff81172cf0>] do_vfs_ioctl+0x2d0/0x4b0
Jan 21 09:42:50 am64 kernel: [  480.570629]  [<ffffffff81496022>] ? _raw_spin_unlock+0x22/0x30
Jan 21 09:42:50 am64 kernel: [  480.576837]  [<ffffffff8117e0d5>] ? set_close_on_exec+0x55/0x70
Jan 21 09:42:50 am64 kernel: [  480.582993]  [<ffffffff81172f61>] SyS_ioctl+0x91/0xb0
Jan 21 09:42:50 am64 kernel: [  480.589101]  [<ffffffff8149e639>] system_call_fastpath+0x16/0x1b
Jan 21 09:42:50 am64 kernel: [  480.595218] 3 locks held by alsactl/4728:
Jan 21 09:42:50 am64 kernel: [  480.601284]  #0:  (&card->power_lock){......}, at: [<ffffffffa024c631>] snd_ctl_elem_info_user+0x61/0x280 [snd]
Jan 21 09:42:50 am64 kernel: [  480.607589]  #1:  (&card->controls_rwsem){......}, at: [<ffffffffa024c659>] snd_ctl_elem_info_user+0x89/0x280 [snd]
Jan 21 09:42:50 am64 kernel: [  480.613944]  #2:  (&per_pin->lock){......}, at: [<ffffffffa05e8ee8>] hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.398023] INFO: task kworker/u12:7:185 blocked for more than 120 seconds.
Jan 21 09:44:50 am64 kernel: [  600.404477]       Not tainted 3.13.0 #633
Jan 21 09:44:50 am64 kernel: [  600.410830] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:44:50 am64 kernel: [  600.417262] kworker/u12:7   D ffff880222d2f010     0   185      2 0x00000000
Jan 21 09:44:50 am64 kernel: [  600.423753] Workqueue: hd-audio1 hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.430227]  ffff8800cb115af0 0000000000000046 ffff88022dad2010 ffff8800cb115fd8
Jan 21 09:44:50 am64 kernel: [  600.436758]  0000000000013880 0000000000013880 ffff88022dad2010 ffff880220a88000
Jan 21 09:44:50 am64 kernel: [  600.443243]  ffff88022dad2010 ffff880220a88330 ffff880220a88328 0000000000000246
Jan 21 09:44:50 am64 kernel: [  600.449756] Call Trace:
Jan 21 09:44:50 am64 kernel: [  600.456196]  [<ffffffff814920c4>] schedule_preempt_disabled+0x24/0x70
Jan 21 09:44:50 am64 kernel: [  600.462704]  [<ffffffff81493083>] mutex_lock_nested+0x143/0x330
Jan 21 09:44:50 am64 kernel: [  600.469215]  [<ffffffffa05ea741>] ? hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.475824]  [<ffffffffa03f8280>] ? jack_detect_update+0x90/0xd0 [snd_hda_codec]
Jan 21 09:44:50 am64 kernel: [  600.482416]  [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.489028]  [<ffffffff81493fc9>] ? mutex_unlock+0x9/0x10
Jan 21 09:44:50 am64 kernel: [  600.495630]  [<ffffffffa05eab81>] generic_hdmi_resume+0x51/0x60 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.502311]  [<ffffffffa03f3560>] hda_call_codec_resume+0x160/0x1c0 [snd_hda_codec]
Jan 21 09:44:50 am64 kernel: [  600.509012]  [<ffffffffa03f37cc>] snd_hda_power_save+0x20c/0x2a0 [snd_hda_codec]
Jan 21 09:44:50 am64 kernel: [  600.515697]  [<ffffffffa03f38bf>] codec_exec_verb+0x5f/0x210 [snd_hda_codec]
Jan 21 09:44:50 am64 kernel: [  600.522339]  [<ffffffffa03f25fa>] snd_hda_codec_read+0x5a/0x90 [snd_hda_codec]
Jan 21 09:44:50 am64 kernel: [  600.528911]  [<ffffffffa05ecdd4>] snd_hdmi_get_eld_ati+0x34/0x43a [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.535420]  [<ffffffffa05e9a6c>] atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.542008]  [<ffffffffa05ea782>] hdmi_present_sense+0x92/0x360 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.548488]  [<ffffffffa05eaa77>] hdmi_repoll_eld+0x27/0x50 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.554951]  [<ffffffff8105c958>] process_one_work+0x1f8/0x500
Jan 21 09:44:50 am64 kernel: [  600.561348]  [<ffffffff8105c8ed>] ? process_one_work+0x18d/0x500
Jan 21 09:44:50 am64 kernel: [  600.567696]  [<ffffffff8105d638>] worker_thread+0x118/0x390
Jan 21 09:44:50 am64 kernel: [  600.573987]  [<ffffffff8105d520>] ? manage_workers.isra.27+0x2a0/0x2a0
Jan 21 09:44:50 am64 kernel: [  600.580311]  [<ffffffff81063687>] kthread+0xf7/0x110
Jan 21 09:44:50 am64 kernel: [  600.586594]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:44:50 am64 kernel: [  600.592861]  [<ffffffff8149e58c>] ret_from_fork+0x7c/0xb0
Jan 21 09:44:50 am64 kernel: [  600.599107]  [<ffffffff81063590>] ? kthread_create_on_node+0x1f0/0x1f0
Jan 21 09:44:50 am64 kernel: [  600.605381] 4 locks held by kworker/u12:7/185:
Jan 21 09:44:50 am64 kernel: [  600.611637]  #0:  (%s#3){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:44:50 am64 kernel: [  600.618053]  #1:  ((&(&per_pin->work)->work)){......}, at: [<ffffffff8105c8ed>] process_one_work+0x18d/0x500
Jan 21 09:44:50 am64 kernel: [  600.624580]  #2:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.631225]  #3:  (&per_pin->lock){......}, at: [<ffffffffa05ea741>] hdmi_present_sense+0x51/0x360 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.637870] INFO: task pulseaudio:4305 blocked for more than 120 seconds.
Jan 21 09:44:50 am64 kernel: [  600.644473]       Not tainted 3.13.0 #633
Jan 21 09:44:50 am64 kernel: [  600.651064] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:44:50 am64 kernel: [  600.657787] pulseaudio      D ffffffff81a114c0     0  4305      1 0x00000000
Jan 21 09:44:50 am64 kernel: [  600.664565]  ffff8800bd1f5d88 0000000000000046 ffff8800bf6ce010 ffff8800bd1f5fd8
Jan 21 09:44:50 am64 kernel: [  600.671400]  0000000000013880 0000000000013880 ffff8800bf6ce010 ffff8800bf6ce010
Jan 21 09:44:50 am64 kernel: [  600.678133]  ffff88022173f198 ffff88022173f1a0 ffffffff00000000 ffff88022173f1d8
Jan 21 09:44:50 am64 kernel: [  600.684800] Call Trace:
Jan 21 09:44:50 am64 kernel: [  600.691377]  [<ffffffff81491c44>] schedule+0x24/0x70
Jan 21 09:44:50 am64 kernel: [  600.697955]  [<ffffffff8149571d>] rwsem_down_write_failed+0xfd/0x1c0
Jan 21 09:44:50 am64 kernel: [  600.704506]  [<ffffffff81268ae3>] call_rwsem_down_write_failed+0x13/0x20
Jan 21 09:44:50 am64 kernel: [  600.711025]  [<ffffffff814950ac>] ? down_write+0x4c/0x60
Jan 21 09:44:50 am64 kernel: [  600.717570]  [<ffffffffa024c528>] ? snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:44:50 am64 kernel: [  600.724102]  [<ffffffffa024c528>] snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:44:50 am64 kernel: [  600.730568]  [<ffffffff811610e2>] __fput+0xe2/0x230
Jan 21 09:44:50 am64 kernel: [  600.736983]  [<ffffffff81161269>] ____fput+0x9/0x10
Jan 21 09:44:50 am64 kernel: [  600.743367]  [<ffffffff8106064f>] task_work_run+0x8f/0xd0
Jan 21 09:44:50 am64 kernel: [  600.749723]  [<ffffffff810028c9>] do_notify_resume+0x69/0xa0
Jan 21 09:44:50 am64 kernel: [  600.756053]  [<ffffffff8149e940>] int_signal+0x12/0x17
Jan 21 09:44:50 am64 kernel: [  600.762345] 1 lock held by pulseaudio/4305:
Jan 21 09:44:50 am64 kernel: [  600.768629]  #0:  (&card->controls_rwsem){......}, at: [<ffffffffa024c528>] snd_ctl_release+0x78/0x120 [snd]
Jan 21 09:44:50 am64 kernel: [  600.775157] INFO: task alsactl:4728 blocked for more than 120 seconds.
Jan 21 09:44:50 am64 kernel: [  600.781663]       Not tainted 3.13.0 #633
Jan 21 09:44:50 am64 kernel: [  600.788158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 21 09:44:50 am64 kernel: [  600.794778] alsactl         D ffff88022d62b010     0  4728   4722 0x00000000
Jan 21 09:44:50 am64 kernel: [  600.801452]  ffff8800bd13bc30 0000000000000046 ffff8802212c4010 ffff8800bd13bfd8
Jan 21 09:44:50 am64 kernel: [  600.808162]  0000000000013880 0000000000013880 ffff8802212c4010 ffff880220a88000
Jan 21 09:44:50 am64 kernel: [  600.814783]  ffff8802212c4010 ffff880220a88330 ffff880220a88328 0000000000000246
Jan 21 09:44:50 am64 kernel: [  600.821351] Call Trace:
Jan 21 09:44:50 am64 kernel: [  600.827767]  [<ffffffff814920c4>] schedule_preempt_disabled+0x24/0x70
Jan 21 09:44:50 am64 kernel: [  600.834170]  [<ffffffff81493083>] mutex_lock_nested+0x143/0x330
Jan 21 09:44:50 am64 kernel: [  600.840528]  [<ffffffffa05e8ee8>] ? hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]
Jan 21 09:44:50 am64 kernel: [  600.846901]  [<ffffffffa05e8ee8>] hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]
Jan 21 09:44:51 am64 kernel: [  600.853243]  [<ffffffffa024c681>] snd_ctl_elem_info_user+0xb1/0x280 [snd]
Jan 21 09:44:51 am64 kernel: [  600.859552]  [<ffffffffa024e93f>] snd_ctl_ioctl+0x7bf/0xbc0 [snd]
Jan 21 09:44:51 am64 kernel: [  600.865786]  [<ffffffff81172cf0>] do_vfs_ioctl+0x2d0/0x4b0
Jan 21 09:44:51 am64 kernel: [  600.872021]  [<ffffffff81496022>] ? _raw_spin_unlock+0x22/0x30
Jan 21 09:44:51 am64 kernel: [  600.878228]  [<ffffffff8117e0d5>] ? set_close_on_exec+0x55/0x70
Jan 21 09:44:51 am64 kernel: [  600.884386]  [<ffffffff81172f61>] SyS_ioctl+0x91/0xb0
Jan 21 09:44:51 am64 kernel: [  600.890495]  [<ffffffff8149e639>] system_call_fastpath+0x16/0x1b
Jan 21 09:44:51 am64 kernel: [  600.896612] 3 locks held by alsactl/4728:
Jan 21 09:44:51 am64 kernel: [  600.902681]  #0:  (&card->power_lock){......}, at: [<ffffffffa024c631>] snd_ctl_elem_info_user+0x61/0x280 [snd]
Jan 21 09:44:51 am64 kernel: [  600.908983]  #1:  (&card->controls_rwsem){......}, at: [<ffffffffa024c659>] snd_ctl_elem_info_user+0x89/0x280 [snd]
Jan 21 09:44:51 am64 kernel: [  600.915330]  #2:  (&per_pin->lock){......}, at: [<ffffffffa05e8ee8>] hdmi_eld_ctl_info+0x48/0x70 [snd_hda_codec_hdmi]

--------------090104030600010207030603--
