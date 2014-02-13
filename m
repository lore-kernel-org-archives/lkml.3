Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBMT6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:58:03 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38272 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaBMT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:57:50 -0500
Date: Thu, 13 Feb 2014 21:58:00 +0100
From: Luis Ortega <luiorpe1@upv.es>
To: Jani Nikula <jani.nikula@intel.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Regression 3.14-rc2] drm/i915: Brightness adjustment is broken
 in 945GM
Message-ID: <20140213205800.GA694@Len.lan_dn>
References: <20140213153458.GA724@Len.lan_dn>
 <87lhxfvytk.fsf@intel.com>
 <20140213162422.GA765@Len.lan_dn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20140213162422.GA765@Len.lan_dn>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Feb 13, 2014 at 05:24:23PM +0100, Luis Ortega wrote:
> > I dare say either your bisect went sour or you don't have 945GM. Please
> > verify your steps.
> 
> Well, what can I say? I was careful when testing and the last kernel I compiled
> shows the problem. I can replay the bisection if needed but if I have to start
> all over again it's gonna take some time. I'm compiling in the netbook and took
> me day and a half to finish the process.
> 
> In all honesty, along the way I met commit messages that I thought were more
> probable to introduce this regression. (backlight related)
> 
> Also, here's the output of lspci:
> 00:00.0 Host bridge: Intel Corporation Mobile 945GSE Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GSE Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
> 
> > Please provide dmesg with drm.debug=0xe with 3.14-rc2.
> 
> Care to explain a bit more before I recompile 3.14-rc2? Do I need to
> enable some particular debug option? How do I proceed for drm.debug=0xe?
> 
> 
> Luis
> > On Thu, Feb 13, 2014 at 05:04:23PM +0200, Jani Nikula wrote:
> > On Thu, 13 Feb 2014, Luis Ortega <luiorpe1@upv.es> wrote:
> > > Hi, testing 3.14-rc2 I noticed I could not adjust the brightness of the
> > > screen any longer. This problem is already present in 3.14-rc1. 3.13 works fine.
> > >
> > > My hardware is a netbook with intel atom and a 945GM graphics card.
> > >
> > > I bisected the problem down to the next commit:
> > 
> > I dare say either your bisect went sour or you don't have 945GM. Please
> > verify your steps.
> > 
> > Please provide dmesg with drm.debug=0xe with 3.14-rc2.
> > 
> > BR,
> > Jani.
> > 
> > >
> > > bc0bb9fd1c7810407ab810d204bbaecb255fddde is the first bad commit
> > > commit bc0bb9fd1c7810407ab810d204bbaecb255fddde
> > > Author: Jani Nikula <jani.nikula@intel.com>
> > > Date:   Thu Nov 14 12:14:29 2013 +0200
> > >
> > >     drm/i915: remove QUIRK_NO_PCH_PWM_ENABLE
> > >     
> > >     The quirk was added as what I'd say was a stopgap measure in
> > >     
> > >     commit e85843bec6c2ea7c10ec61238396891cc2b753a9
> > >     Author: Kamal Mostafa <kamal@canonical.com>
> > >     Date:   Fri Jul 19 15:02:01 2013 -0700
> > >     
> > >         drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
> > >     
> > >     without really digging into what was going on.
> > >     
> > >     Also, as mentioned in the related bug [1], having the quirk regressed
> > >     some of the machines it was supposed to fix to begin with, and there
> > >     were patches posted to disable the quirk on such machines [2]!
> > >     
> > >     The fact is, we do need the BLM_PCH_PWM_ENABLE bit set to have
> > >     backlight. With the quirk, we've relied on BIOS to have set it, and our
> > >     save/restore code to retain it. With the full backlight setup at enable,
> > >     we have no place for things that rely on previous state.
> > >     
> > >     With the per platform hooks, we've also made a change in the PCH
> > >     platform enable order: setting the backlight duty cycle between CPU and
> > >     PCH PWM enable. Some experimenting and
> > >     
> > >     commit 770c12312ad617172b1a65b911d3e6564fc5aca8
> > >     Author: Takashi Iwai <tiwai@suse.de>
> > >     Date:   Sat Aug 11 08:56:42 2012 +0200
> > >     
> > >         drm/i915: Fix blank panel at reopening lid
> > >     
> > >     indicate that we can't set the backlight before enabling CPU PWM; the
> > >     value just won't stick. But AFAICT we should do it before enabling the
> > >     PCH PWM.
> > >     
> > >     Finally, any fallout we should fix properly, preferrably without quirks,
> > >     and absolutely without quirks that rely on existing state. With the per
> > >     platform hooks have much more flexibility to adjust the sequence as
> > >     required by platforms.
> > >     
> > >     [1] https://bugzilla.kernel.org/show_bug.cgi?id=47941
> > >     [2] http://lkml.kernel.org/r/1378229848-29113-1-git-send-email-kamal@canonical.com
> > >     
> > >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > >     Reviewed-by: Imre Deak <imre.deak@intel.com>
> > >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > >
> > >
> > > Additionally, when I had narrowed the problem to around 11 commits all the
> > > resulting kernel I compiled made the screen blink and shake from left to right
> > > non-stop. In the -rc kernels this doesn't happen. Thought it was worth
> > > mentioning.
> > 
> > 
> > -- 
> > Jani Nikula, Intel Open Source Technology Center

> Please provide dmesg with drm.debug=0xe with 3.14-rc2.

I've booted with the kernel args drm.debug=0xe log_buf_len=16M.
I've attached the following files for your inspection:

dmesg.txt - dmesg output
lspci.txt - output of: su -c 'lspci -nn'
/var/log/Xorg.0.log

Ask me if there is anything else I can do to help.

Luis

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.14.0-1-rc (luis@Len) (gcc version 4.8.2 20140206 (prerelease) (GCC) ) #1 SMP PREEMPT Thu Feb 13 21:20:32 CET 2014
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f79ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f7a0000-0x000000007f7adfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007f7ae000-0x000000007f7effff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f7f0000-0x000000007f7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ASUSTeK Computer INC. 1000H/1000H, BIOS 2003    06/11/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7f7a0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 base 07F800000 mask 0FF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x0182e000, 0x0182efff] PGTABLE
[    0.000000] log_buf_len: 16777216
[    0.000000] early log buf free: 62600(95%)
[    0.000000] ACPI: RSDP 000fb9e0 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 7f7a0000 00003C (v01 A_M_I_ OEMRSDT  06000911 MSFT 00000097)
[    0.000000] ACPI: FACP 7f7a0200 000084 (v02 A_M_I_ OEMFACP  06000911 MSFT 00000097)
[    0.000000] ACPI: DSDT 7f7a0430 005342 (v01  A1028 A1028000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 7f7ae000 000040
[    0.000000] ACPI: APIC 7f7a0390 00005C (v01 A_M_I_ OEMAPIC  06000911 MSFT 00000097)
[    0.000000] ACPI: MCFG 7f7a03f0 00003C (v01 A_M_I_ OEMMCFG  06000911 MSFT 00000097)
[    0.000000] ACPI: OEMB 7f7ae040 000061 (v01 A_M_I_ AMI_OEM  06000911 MSFT 00000097)
[    0.000000] ACPI: HPET 7f7a5780 000038 (v01 A_M_I_ OEMHPET  06000911 MSFT 00000097)
[    0.000000] ACPI: SSDT 7f7aeb80 0004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x0182f000, 0x0182ffff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7f79ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7f79ffff]
[    0.000000] On node 0 totalpages: 522046
[    0.000000] free_area_init_node: node 0, pgdat c1765680, node_mem_map f580e020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2304 pages used for memmap
[    0.000000]   HighMem zone: 294818 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e2000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfedfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f57ea000 s27712 r0 d21440 u49152
[    0.000000] pcpu-alloc: s27712 r0 d21440 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520270
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux-rc root=/dev/sda2 rw drm.debug=0xe log_buf_len=16M native
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f7a0)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 2046080K/2088184K available (5547K kernel code, 325K rwdata, 1724K rodata, 404K init, 316K bss, 42104K reserved, 1179272K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc176d000 - 0xc17d2000   ( 404 kB)
      .data : 0xc156afba - 0xc176c540   (2053 kB)
      .text : 0xc1000000 - 0xc156afba   (5547 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5008000 soft=f500a000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1596.027 MHz processor
[    0.004014] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.05 BogoMIPS (lpj=6384108)
[    0.004034] pid_max: default: 32768 minimum: 301
[    0.004094] Security Framework initialized
[    0.004119] Mount-cache hash table entries: 512
[    0.004507] Initializing cgroup subsys devices
[    0.004522] Initializing cgroup subsys freezer
[    0.004533] Initializing cgroup subsys blkio
[    0.004583] Disabled fast string operations
[    0.004597] CPU: Physical Processor ID: 0
[    0.004605] CPU: Processor Core ID: 0
[    0.004614] mce: CPU supports 5 MCE banks
[    0.004632] CPU0: Thermal monitoring enabled (TM2)
[    0.004661] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8, 1GB 0
tlb_flushall_shift: 6
[    0.004841] Freeing SMP alternatives memory: 20K (c17d2000 - c17d7000)
[    0.004968] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.005470] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.047284] smpboot: CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz (fam: 06, model: 1c, stepping: 02)
[    0.048000] Performance Events: PEBS fmt0+, LBR disabled due to erratumAtom events, Intel PMU driver.
[    0.048000] ... version:                3
[    0.048000] ... bit width:              40
[    0.048000] ... generic registers:      2
[    0.048000] ... value mask:             000000ffffffffff
[    0.048000] ... max period:             000000007fffffff
[    0.048000] ... fixed-purpose events:   3
[    0.048000] ... event mask:             0000000700000003
[    0.068130] CPU 1 irqstacks, hard=f5096000 soft=f50a0000
[    0.068136] x86: Booting SMP configuration:
[    0.068148] .... node  #0, CPUs:      #1
[    0.008000] Initializing CPU#1
[    0.008000] Disabled fast string operations
[    0.080091] x86: Booted up 1 node, 2 CPUs
[    0.080122] smpboot: Total of 2 processors activated (6384.10 BogoMIPS)
[    0.080653] devtmpfs: initialized
[    0.080699] PM: Registering ACPI NVS region [mem 0x7f7ae000-0x7f7effff] (270336 bytes)
[    0.080699] RTC time: 20:36:00, date: 02/13/14
[    0.080699] NET: Registered protocol family 16
[    0.080922] cpuidle: using governor ladder
[    0.080934] cpuidle: using governor menu
[    0.081063] ACPI: bus type PCI registered
[    0.081220] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.081237] PCI: not using MMCONFIG
[    0.081547] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.081558] PCI: Using configuration type 1 for base access
[    0.089766] bio: create slab <bio-0> at 0
[    0.089766] ACPI: Added _OSI(Module Device)
[    0.089766] ACPI: Added _OSI(Processor Device)
[    0.089766] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.089766] ACPI: Added _OSI(Processor Aggregator Device)
[    0.095960] ACPI: Executed 1 blocks of module-level executable AML code
[    0.100637] ACPI: SSDT 7f7ae180 00023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.101192] ACPI: Dynamic OEM Table Load:
[    0.101205] ACPI: SSDT   (null) 00023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.101494] ACPI: SSDT 7f7ae450 000724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.104288] ACPI: Dynamic OEM Table Load:
[    0.104301] ACPI: SSDT   (null) 000724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.104790] ACPI: SSDT 7f7ae0b0 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.105329] ACPI: Dynamic OEM Table Load:
[    0.105342] ACPI: SSDT   (null) 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.105511] ACPI: SSDT 7f7ae3c0 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.106027] ACPI: Dynamic OEM Table Load:
[    0.106039] ACPI: SSDT   (null) 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.106646] ACPI: Interpreter enabled
[    0.106678] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
[    0.106699] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.106742] ACPI: (supports S0 S3 S4 S5)
[    0.106752] ACPI: Using IOAPIC for interrupt routing
[    0.106816] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.107863] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.107879] PCI: Using MMCONFIG for extended config space
[    0.107933] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.122217] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.122244] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.122268] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.122546] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.122684] PCI host bridge to bus 0000:00
[    0.122699] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.122711] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.122723] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.122735] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.122748] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.122760] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xffffffff]
[    0.122788] pci 0000:00:00.0: [8086:27ac] type 00 class 0x060000
[    0.123040] pci 0000:00:02.0: [8086:27ae] type 00 class 0x030000
[    0.123061] pci 0000:00:02.0: reg 0x10: [mem 0xf7f00000-0xf7f7ffff]
[    0.123073] pci 0000:00:02.0: reg 0x14: [io  0xdc00-0xdc07]
[    0.123084] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff pref]
[    0.123096] pci 0000:00:02.0: reg 0x1c: [mem 0xf7ec0000-0xf7efffff]
[    0.123338] pci 0000:00:02.1: [8086:27a6] type 00 class 0x038000
[    0.123356] pci 0000:00:02.1: reg 0x10: [mem 0xf7f80000-0xf7ffffff]
[    0.123657] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.123691] pci 0000:00:1b.0: reg 0x10: [mem 0xf7eb8000-0xf7ebbfff 64bit]
[    0.123831] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.123944] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.124114] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.124251] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.124366] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.124519] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.124665] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.124786] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.124945] pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
[    0.125091] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.125205] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.125369] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.125441] pci 0000:00:1d.0: reg 0x20: [io  0xd400-0xd41f]
[    0.125679] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.125750] pci 0000:00:1d.1: reg 0x20: [io  0xd480-0xd49f]
[    0.125990] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.126062] pci 0000:00:1d.2: reg 0x20: [io  0xd800-0xd81f]
[    0.126301] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.126373] pci 0000:00:1d.3: reg 0x20: [io  0xd880-0xd89f]
[    0.126622] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.126657] pci 0000:00:1d.7: reg 0x10: [mem 0xf7eb7c00-0xf7eb7fff]
[    0.126785] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.127026] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.127204] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.127361] pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
[    0.127484] pci 0000:00:1f.0: address space collision: [io  0x0800-0x087f] conflicts with ACPI CPU throttle [??? 0x00000810-0x00000815 flags 0x80000000]
[    0.127509] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.127524] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0380 (mask 0003)
[    0.127541] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
[    0.127557] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0003)
[    0.127824] pci 0000:00:1f.2: [8086:27c4] type 00 class 0x010180
[    0.127855] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.127872] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.127889] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.127906] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.127924] pci 0000:00:1f.2: reg 0x20: [io  0xffa0-0xffaf]
[    0.127993] pci 0000:00:1f.2: PME# supported from D3hot
[    0.128367] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.128554] pci 0000:03:00.0: [1969:1026] type 00 class 0x020000
[    0.128596] pci 0000:03:00.0: reg 0x10: [mem 0xfbfc0000-0xfbffffff 64bit]
[    0.128619] pci 0000:03:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.128789] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.128953] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.128975] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.128990] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.129000] pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.129173] pci 0000:01:00.0: [1814:0781] type 00 class 0x028000
[    0.129204] pci 0000:01:00.0: reg 0x10: [mem 0xfbef0000-0xfbefffff]
[    0.129388] pci 0000:01:00.0: PME# supported from D0 D3hot
[    0.136036] pci 0000:00:1c.3: PCI bridge to [bus 01-02]
[    0.136058] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xfbefffff]
[    0.136071] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.136233] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.136261] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.136267] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.136274] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.136280] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.136286] pci 0000:00:1e.0:   bridge window [mem 0x7f800000-0xffffffff] (subtractive decode)
[    0.136331] pci_bus 0000:00: on NUMA node 0
[    0.136856] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.137017] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.137174] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.137337] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.137494] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.137654] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.137815] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.137977] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.138274] ACPI : EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.138451] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.138451] vgaarb: loaded
[    0.138451] vgaarb: bridge control possible 0000:00:02.0
[    0.138451] SCSI subsystem initialized
[    0.138451] libata version 3.00 loaded.
[    0.138451] ACPI: bus type USB registered
[    0.138451] usbcore: registered new interface driver usbfs
[    0.138451] usbcore: registered new interface driver hub
[    0.138451] usbcore: registered new device driver usb
[    0.138451] Linux video capture interface: v2.00
[    0.138451] Advanced Linux Sound Architecture Driver Initialized.
[    0.138451] PCI: Using ACPI for IRQ routing
[    0.138451] PCI: pci_cache_line_size set to 64 bytes
[    0.138451] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.138451] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.138451] e820: reserve RAM buffer [mem 0x7f7a0000-0x7fffffff]
[    0.140066] NetLabel: Initializing
[    0.140066] NetLabel:  domain hash size = 128
[    0.140066] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.140081] NetLabel:  unlabeled traffic allowed by default
[    0.140145] cfg80211: Calling CRDA to update world regulatory domain
[    0.140212] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.140232] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.140248] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.142291] Switched to clocksource hpet
[    0.142291] pnp: PnP ACPI init
[    0.142291] ACPI: bus type PNP registered
[    0.142291] system 00:00: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.142291] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.142291] pnp 00:01: [dma 4]
[    0.142291] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.142291] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.142291] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.142291] pnp 00:04: Plug and Play ACPI device, IDs SYN0a04 SYN0a00 SYN0002 PNP0f13 (active)
[    0.142291] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.142291] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.142291] system 00:07: [io  0x025c-0x025f] has been reserved
[    0.142291] system 00:07: [io  0x0380-0x0383] has been reserved
[    0.142291] system 00:07: [io  0x0400-0x041f] has been reserved
[    0.142291] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.142291] system 00:07: [io  0x0800-0x087f] could not be reserved
[    0.142291] system 00:07: [io  0x0480-0x04bf] has been reserved
[    0.142291] system 00:07: [mem 0x8c000000-0x8c01ffff] has been reserved
[    0.142291] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.142291] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.142291] system 00:07: [mem 0xfed50000-0xfed8ffff] has been reserved
[    0.142291] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.142291] system 00:07: [mem 0xfff00000-0xffffffff] could not be reserved
[    0.142291] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.142291] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.142291] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.142304] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.142319] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.142498] system 00:0a: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.142514] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.142991] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.143008] system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.143022] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.143036] system 00:0b: [mem 0x00100000-0x7f7fffff] could not be reserved
[    0.143050] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.143389] pnp: PnP ACPI: found 12 devices
[    0.143400] ACPI: bus type PNP unregistered
[    0.185769] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.185781] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.185789] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000
[    0.185808] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.185827] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 01-02] add_size 1000
[    0.185850] pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
[    0.185871] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.185878] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.185885] pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.185892] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.185899] pci 0000:00:1c.3: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.185912] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.185928] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.185946] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x805fffff 64bit pref]
[    0.185964] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.185978] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.185991] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.186005] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.186022] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.186038] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.186059] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.186072] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.186089] pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.186105] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
[    0.186126] pci 0000:00:1c.3: PCI bridge to [bus 01-02]
[    0.186139] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.186155] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xfbefffff]
[    0.186171] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.186192] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.186218] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.186225] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.186231] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.186237] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.186243] pci_bus 0000:00: resource 8 [mem 0x7f800000-0xffffffff]
[    0.186249] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.186255] pci_bus 0000:04: resource 1 [mem 0x80000000-0x801fffff]
[    0.186262] pci_bus 0000:04: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.186268] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.186274] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.186280] pci_bus 0000:03: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
[    0.186287] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.186293] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbefffff]
[    0.186299] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.186305] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.186311] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.186317] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.186323] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.186330] pci_bus 0000:05: resource 8 [mem 0x7f800000-0xffffffff]
[    0.186404] NET: Registered protocol family 2
[    0.186729] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.186784] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.186849] TCP: Hash tables configured (established 8192 bind 8192)
[    0.186946] TCP: reno registered
[    0.186959] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.186982] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.187110] NET: Registered protocol family 1
[    0.187157] pci 0000:00:02.0: Boot video device
[    0.188367] PCI: CLS 32 bytes, default 64
[    0.189787] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.189840] audit: initializing netlink subsys (disabled)
[    0.189892] audit: type=2000 audit(1392323760.188:1): initialized
[    0.190480] bounce pool size: 64 pages
[    0.190521] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.198492] msgmni has been set to 1693
[    0.202654] alg: No test for lz4 (lz4-generic)
[    0.202734] alg: No test for stdrng (krng)
[    0.202913] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.202930] io scheduler noop registered
[    0.202939] io scheduler deadline registered
[    0.203067] io scheduler cfq registered (default)
[    0.203238] pcieport 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.203440] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.203748] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.203916] pcieport 0000:00:1c.3: enabling device (0106 -> 0107)
[    0.204116] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.204348] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.204461] intel_idle: MWAIT substates: 0x20220
[    0.204478] intel_idle: v0.4 model 0x1C
[    0.204483] intel_idle: lapic_timer_reliable_states 0x2
[    0.204496] tsc: Marking TSC unstable due to TSC halts in idle states deeper than C2
[    0.205010] ACPI: AC Adapter [AC0] (on-line)
[    0.205235] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.210124] ACPI: Lid Switch [LID]
[    0.210289] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.210309] ACPI: Sleep Button [SLPB]
[    0.210468] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.210486] ACPI: Power Button [PWRB]
[    0.210649] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.210666] ACPI: Power Button [PWRF]
[    0.210885] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    0.211170] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    0.229844] thermal LNXTHERM:00: registered as thermal_zone0
[    0.229877] ACPI: Thermal Zone [TZ00] (58 C)
[    0.230128] ACPI: Battery Slot [BAT0] (battery absent)
[    0.230525] Linux agpgart interface v0.103
[    0.230589] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    0.230676] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    0.230807] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.231101] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.231197] [drm] Initialized drm 1.1.0 20060810
[    0.231986] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x27ae flags=is_mobile,is_i945gm,has_fbc,has_hotplug,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
[    0.232128] [drm:intel_detect_pch], No PCH found?
[    0.232136] [drm] Memory usable by graphics device = 256M
[    0.232150] [drm:i915_gem_gtt_init], GMADR size = 256M
[    0.232154] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    0.232643] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    0.232648] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    0.232682] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.232693] [drm] Driver supports precise vblank timestamp query.
[    0.232705] [drm:init_vbt_defaults], Set default to SSC at 100000 kHz
[    0.233104] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 1 lvds_ssc_freq 100000 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    0.233110] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.233141] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    0.233150] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.233167] [drm:parse_lfp_panel_data], VBT initial LVDS value 40000300
[    0.233182] [drm:parse_lfp_backlight], VBT backlight PWM modulation frequency 20000 Hz, active high, min brightness 0, level 0
[    0.233202] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    0.233210] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    0.233217] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.233248] [drm:parse_mipi], No MIPI BDB found
[    0.233264] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    0.233276] [drm:i915_gem_init_stolen], found 8388608 bytes of stolen memory at 7f800000
[    0.233344] [drm:intel_modeset_init], 2 display pipes available.
[    0.233357] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    0.233363] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    0.233374] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    0.233379] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    0.233388] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.316184] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 156
[    0.316219] Raw EDID:
[    0.316237]  	00 ff ff ff ff ff ff 00 22 64 e9 03 fd 9e 01 00
[    0.316256]  	12 12 01 03 80 16 0d 78 0a 80 36 9a 5e 5d 91 28
[    0.316275]  	20 4f 54 00 00 00 01 01 01 01 01 01 01 01 01 01
[    0.316294]  	01 01 01 01 01 01 94 11 00 b0 40 58 19 20 35 23
[    0.316313]  	45 00 dc 81 00 00 00 19 00 00 00 fd 00 37 41 22
[    0.316332]  	29 05 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.316351]  	53 44 31 30 30 49 46 57 31 0a 20 20 00 00 00 10
[    0.316369]  	00 0a 20 20 20 20 20 20 20 20 20 20 20 20 00 81
[    0.388170] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 156
[    0.388204] Raw EDID:
[    0.388221]  	00 ff ff ff ff ff ff 00 22 64 e9 03 fd 9e 01 00
[    0.388240]  	12 12 01 03 80 16 0d 78 0a 80 36 9a 5e 5d 91 28
[    0.388259]  	20 4f 54 00 00 00 01 01 01 01 01 01 01 01 01 01
[    0.388278]  	01 01 01 01 01 01 94 11 00 b0 40 58 19 20 35 23
[    0.388297]  	45 00 dc 81 00 00 00 19 00 00 00 fd 00 37 41 22
[    0.388316]  	29 05 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.388335]  	53 44 31 30 30 49 46 57 31 0a 20 20 00 00 00 10
[    0.388354]  	00 0a 20 20 20 20 20 20 20 20 20 20 20 20 00 81
[    0.460181] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 156
[    0.460215] Raw EDID:
[    0.460232]  	00 ff ff ff ff ff ff 00 22 64 e9 03 fd 9e 01 00
[    0.460252]  	12 12 01 03 80 16 0d 78 0a 80 36 9a 5e 5d 91 28
[    0.460270]  	20 4f 54 00 00 00 01 01 01 01 01 01 01 01 01 01
[    0.460289]  	01 01 01 01 01 01 94 11 00 b0 40 58 19 20 35 23
[    0.460308]  	45 00 dc 81 00 00 00 19 00 00 00 fd 00 37 41 22
[    0.460327]  	29 05 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.460346]  	53 44 31 30 30 49 46 57 31 0a 20 20 00 00 00 10
[    0.460365]  	00 0a 20 20 20 20 20 20 20 20 20 20 20 20 00 81
[    0.532170] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 156
[    0.532204] Raw EDID:
[    0.532221]  	00 ff ff ff ff ff ff 00 22 64 e9 03 fd 9e 01 00
[    0.532240]  	12 12 01 03 80 16 0d 78 0a 80 36 9a 5e 5d 91 28
[    0.532259]  	20 4f 54 00 00 00 01 01 01 01 01 01 01 01 01 01
[    0.532278]  	01 01 01 01 01 01 94 11 00 b0 40 58 19 20 35 23
[    0.532297]  	45 00 dc 81 00 00 00 19 00 00 00 fd 00 37 41 22
[    0.532316]  	29 05 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.532335]  	53 44 31 30 30 49 46 57 31 0a 20 20 00 00 00 10
[    0.532354]  	00 0a 20 20 20 20 20 20 20 20 20 20 20 20 00 81
[    0.532383] i915 0000:00:02.0: LVDS-1: EDID block 0 invalid.
[    0.532406] [drm:intel_lvds_init], using mode from VBT: 
[    0.532424] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.532443] [drm:intel_lvds_init], detected single-link lvds configuration
[    0.532648] [drm:intel_panel_setup_backlight], backlight initialized, enabled, brightness 156/156, sysfs interface registered
[    0.532764] [drm:intel_tv_init], Integrated TV is not present.
[    0.532774] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
[    0.533541] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    0.533549] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    0.533721] [drm] initialized overlay support
[    0.533741] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[    0.533754] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    0.533763] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
[    0.533769] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] hw state readout: disabled, pipe A
[    0.533776] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
[    0.533782] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] hw state readout: disabled
[    0.533790] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    0.533795] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    0.533799] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    0.533805] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.533811] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.533815] [drm:intel_dump_pipe_config], requested mode:
[    0.533822] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.533827] [drm:intel_dump_pipe_config], adjusted mode:
[    0.533834] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.533841] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    0.533845] [drm:intel_dump_pipe_config], port clock: 0
[    0.533849] [drm:intel_dump_pipe_config], pipe src size: 0x0
[    0.533854] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    0.533859] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    0.533864] [drm:intel_dump_pipe_config], ips: 0
[    0.533868] [drm:intel_dump_pipe_config], double wide: 0
[    0.533873] [drm:intel_sanitize_crtc], [CRTC:4] wrong plane connection detected!
[    0.533879] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[    0.833095] [drm:i9xx_pfit_disable], disabling pfit, current: 0x80002668
[    0.833107] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    0.833114] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    0.833119] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    0.833124] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    0.833129] [drm:i9xx_update_wm], memory self refresh disabled
[    0.833134] [drm:intel_update_fbc], no output, disabling
[    0.833142] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    0.833146] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    0.833151] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    0.833157] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.833163] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.833167] [drm:intel_dump_pipe_config], requested mode:
[    0.833175] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 800 0 0 0 600 0 0 0 0x0 0x0
[    0.833179] [drm:intel_dump_pipe_config], adjusted mode:
[    0.833186] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    0.833194] [drm:intel_dump_crtc_timings], crtc timings: 50000 1024 1044 1054 1344 600 602 605 625, type: 0x0 flags: 0xa
[    0.833198] [drm:intel_dump_pipe_config], port clock: 50000
[    0.833203] [drm:intel_dump_pipe_config], pipe src size: 800x600
[    0.833208] [drm:intel_dump_pipe_config], gmch pfit: control: 0x80002668, ratios: 0x00000000, lvds border: 0x00000000
[    0.833213] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    0.833218] [drm:intel_dump_pipe_config], ips: 0
[    0.833222] [drm:intel_dump_pipe_config], double wide: 0
[    0.833229] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    0.833235] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    0.833240] [drm:check_crtc_state], [CRTC:3]
[    0.833245] [drm:check_crtc_state], [CRTC:4]
[    0.833263] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    0.833268] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    0.833280] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    0.833289] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.833295] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    0.833300] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[    0.848154] [drm:intel_crt_detect], CRT not detected via hotplug
[    0.852167] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    0.852184] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.852193] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    0.852204] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    0.852513] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.852519] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    0.852523] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    0.852531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    0.852538] [drm:drm_setup_crtcs], 
[    0.852544] [drm:drm_enable_connectors], connector 5 enabled? yes
[    0.852549] [drm:drm_enable_connectors], connector 9 enabled? no
[    0.852554] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    0.852558] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    0.852563] [drm:drm_target_preferred], found mode 1024x600
[    0.852568] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    0.852575] [drm:drm_setup_crtcs], desired mode 1024x600 set on crtc 4
[    0.852591] [drm:intelfb_create], no BIOS fb, allocating a new one
[    0.852597] [drm:i915_gem_object_create_stolen], creating stolen object: size=258000
[    0.852604] [drm:i915_pages_create_for_stolen], offset=0x20000, size=2457600
[    0.855262] [drm:intelfb_create], allocated 1024x600 fb: 0x00020000, bo f52aa100
[    0.855473] fbcon: inteldrmfb (fb0) is primary device
[    0.855570] [drm:intel_crtc_set_config], [CRTC:3] [NOFB]
[    0.855575] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    0.855580] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[    0.855582] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    0.855585] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    0.855590] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.855597] [drm:drm_mode_debug_printmodeline], Modeline 12:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.855600] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=1, fb_changed=0
[    0.855602] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[    0.855605] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    0.855607] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    0.855612] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    0.855618] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
[    0.855622] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    0.855626] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    0.855629] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    0.855631] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    0.855634] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    0.855638] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.855641] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.855643] [drm:intel_dump_pipe_config], requested mode:
[    0.855649] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.855651] [drm:intel_dump_pipe_config], adjusted mode:
[    0.855657] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x600" 0 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[    0.855662] [drm:intel_dump_crtc_timings], crtc timings: 50000 1024 1044 1054 1344 600 602 605 625, type: 0x8 flags: 0xa
[    0.855664] [drm:intel_dump_pipe_config], port clock: 50000
[    0.855666] [drm:intel_dump_pipe_config], pipe src size: 1024x600
[    0.855669] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000008, ratios: 0x00000000, lvds border: 0x00000000
[    0.855672] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    0.855674] [drm:intel_dump_pipe_config], ips: 0
[    0.855676] [drm:intel_dump_pipe_config], double wide: 0
[    0.855684] [drm:i9xx_get_refclk], using SSC reference clock of 100000 kHz
[    0.856089] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 4096
[    0.856097] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1024x600]
[    0.856745] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    0.856748] [drm:intel_calculate_wm], FIFO entries required for mode: 16
[    0.856750] [drm:intel_calculate_wm], FIFO watermark level: 10
[    0.856753] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    0.856756] [drm:i9xx_update_wm], FIFO watermarks - A: 10, B: 29
[    0.856758] [drm:i9xx_update_wm], self-refresh entries: 64
[    0.856761] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 10, B: 29, C: 2, SR 63
[    0.856764] [drm:i9xx_update_wm], memory self refresh enabled
[    0.880170] [drm:intel_update_fbc], disabled per chip default
[    1.264166] [drm:intel_panel_enable_backlight], pipe B
[    1.264177] [drm:intel_panel_actually_set_backlight], set backlight PWM = 156
[    1.264193] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.264201] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.264208] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    1.264215] [drm:check_crtc_state], [CRTC:3]
[    1.264220] [drm:check_crtc_state], [CRTC:4]
[    1.264323] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[    1.264332] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    1.264340] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    1.272258] Console: switching to colour frame buffer device 128x37
[    1.272270] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[    1.272274] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    1.272278] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    1.280459] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.280588] i915 0000:00:02.0: registered panic notifier
[    1.280718] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.286209] brd: module loaded
[    1.286499] ata_piix 0000:00:1f.2: version 2.13
[    1.286666] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.289562] scsi0 : ata_piix
[    1.289972] scsi1 : ata_piix
[    1.290212] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.290361] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.290749] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.290889] ehci-pci: EHCI PCI platform driver
[    1.294108] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.297067] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.300085] ehci-pci 0000:00:1d.7: debug port 1
[    1.306943] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    1.306994] ehci-pci 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    1.320040] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.323055] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.326024] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.329011] usb usb1: Product: EHCI Host Controller
[    1.331978] usb usb1: Manufacturer: Linux 3.14.0-1-rc ehci_hcd
[    1.334981] usb usb1: SerialNumber: 0000:00:1d.7
[    1.338393] hub 1-0:1.0: USB hub found
[    1.341354] hub 1-0:1.0: 8 ports detected
[    1.344863] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.347802] ohci-pci: OHCI PCI platform driver
[    1.350776] uhci_hcd: USB Universal Host Controller Interface driver
[    1.353935] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.356905] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.359929] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    1.363052] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.366102] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.369167] usb usb2: Product: UHCI Host Controller
[    1.372224] usb usb2: Manufacturer: Linux 3.14.0-1-rc uhci_hcd
[    1.375279] usb usb2: SerialNumber: 0000:00:1d.0
[    1.378693] hub 2-0:1.0: USB hub found
[    1.381724] hub 2-0:1.0: 2 ports detected
[    1.385135] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.388123] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.391178] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
[    1.394278] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.397235] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.400196] usb usb3: Product: UHCI Host Controller
[    1.403122] usb usb3: Manufacturer: Linux 3.14.0-1-rc uhci_hcd
[    1.406140] usb usb3: SerialNumber: 0000:00:1d.1
[    1.409493] hub 3-0:1.0: USB hub found
[    1.412508] hub 3-0:1.0: 2 ports detected
[    1.415865] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.418826] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.421903] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    1.425011] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.427999] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.431029] usb usb4: Product: UHCI Host Controller
[    1.434064] usb usb4: Manufacturer: Linux 3.14.0-1-rc uhci_hcd
[    1.437083] usb usb4: SerialNumber: 0000:00:1d.2
[    1.440463] hub 4-0:1.0: USB hub found
[    1.443408] hub 4-0:1.0: 2 ports detected
[    1.446953] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.449928] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.453017] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
[    1.453219] ata1.00: ATA-8: ST9160827AS, 3.AAA, max UDMA/133
[    1.453225] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.462252] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.465298] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.468333] usb usb5: Product: UHCI Host Controller
[    1.468594] ata1.00: configured for UDMA/133
[    1.468918] scsi 0:0:0:0: Direct-Access     ATA      ST9160827AS      3.AA PQ: 0 ANSI: 5
[    1.469724] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.470031] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.470273] sd 0:0:0:0: [sda] Write Protect is off
[    1.470280] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.470379] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.490415] usb usb5: Manufacturer: Linux 3.14.0-1-rc uhci_hcd
[    1.493632] usb usb5: SerialNumber: 0000:00:1d.3
[    1.497246] hub 5-0:1.0: USB hub found
[    1.500443] hub 5-0:1.0: 2 ports detected
[    1.503985] usbcore: registered new interface driver usb-storage
[    1.507305] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.517991]  sda: sda1 sda2 sda3
[    1.523100] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.536381] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.539684] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.543124] mousedev: PS/2 mouse device common for all mice
[    1.547278] rtc_cmos 00:02: RTC can wake from S4
[    1.550842] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.554175] rtc_cmos 00:02: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.557704] md: multipath personality registered for level -4
[    1.561363] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.565929] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    1.566151] Netfilter messages via NETLINK v0.30.
[    1.569756] TCP: cubic registered
[    1.573096] Key type dns_resolver registered
[    1.576699] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.580552] Using IPI No-Shortcut mode
[    1.593070] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    1.598020] registered taskstats version 1
[    1.602516] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    1.606332]   Magic number: 2:654:649
[    1.610716] rtc_cmos 00:02: setting system clock to 2014-02-13 20:36:02 UTC (1392323762)
[    1.615551] PM: Hibernation image not present or could not be loaded.
[    1.615557] ALSA device list:
[    1.619345]   #0: HDA Intel at 0xf7eb8000 irq 43
[    1.660219] usb 1-8: new high-speed USB device number 2 using ehci-pci
[    1.845028] usb 1-8: New USB device found, idVendor=04f2, idProduct=b071
[    1.852794] usb 1-8: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    1.860552] usb 1-8: Product: CNF7129
[    1.864655] usb 1-8: Manufacturer: Chicony Electronics Co., Ltd.
[    1.868446] usb 1-8: SerialNumber: SN0001
[    2.734448] psmouse serio1: elantech: assuming hardware version 2 (with firmware version 0x020030)
[    2.814343] psmouse serio1: elantech: Synaptics capabilities query result 0x00, 0x02, 0x64.
[    3.030418] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input9
[    3.043703] md: Waiting for all devices to be available before autodetect
[    3.049479] md: If you don't use raid, use raid=noautodetect
[    3.056233] md: Autodetecting RAID arrays.
[    3.060254] md: Scanned 0 and added 0 devices.
[    3.064123] md: autorun ...
[    3.067872] md: ... autorun DONE.
[    3.115791] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    3.120303] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    3.149515] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.153650] VFS: Mounted root (ext4 filesystem) on device 8:2.
[    3.179807] devtmpfs: mounted
[    3.184421] Freeing unused kernel memory: 404K (c176d000 - c17d2000)
[    3.188613] Write protecting the kernel text: 5548k
[    3.192709] Write protecting the kernel read-only data: 1728k
[    4.003990] systemd[1]: systemd 208 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    4.200980] systemd[1]: Inserted module 'autofs4'
[    4.240798] NET: Registered protocol family 10
[    4.245110] systemd[1]: Inserted module 'ipv6'
[    4.256768] systemd[1]: Set hostname to <Len>.
[    4.291875] random: systemd urandom read with 89 bits of entropy available
[    4.956996] random: nonblocking pool is initialized
[    5.258827] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    5.262708] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    5.266399] systemd[1]: Starting Remote File Systems.
[    5.273717] systemd[1]: Reached target Remote File Systems.
[    5.277361] systemd[1]: Expecting device sys-subsystem-net-devices-wlp1s0.device...
[    5.284815] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    5.292451] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    5.296165] systemd[1]: Starting LVM2 metadata daemon socket.
[    5.303574] systemd[1]: Listening on LVM2 metadata daemon socket.
[    5.307200] systemd[1]: Starting Delayed Shutdown Socket.
[    5.314606] systemd[1]: Listening on Delayed Shutdown Socket.
[    5.318303] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    5.325946] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    5.329710] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    5.333577] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    5.337369] systemd[1]: Starting Paths.
[    5.344849] systemd[1]: Reached target Paths.
[    5.348527] systemd[1]: Starting Encrypted Volumes.
[    5.355837] systemd[1]: Reached target Encrypted Volumes.
[    5.359335] systemd[1]: Starting Journal Socket.
[    5.366669] systemd[1]: Listening on Journal Socket.
[    5.401149] systemd[1]: Started Load Kernel Modules.
[    5.405033] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    5.413879] systemd[1]: Mounting POSIX Message Queue File System...
[    5.422908] systemd[1]: Starting Setup Virtual Console...
[    5.432360] systemd[1]: Mounting Debug File System...
[    5.476517] systemd[1]: Starting Apply Kernel Variables...
[    5.485269] systemd[1]: Mounting Configuration File System...
[    5.494208] systemd[1]: Mounting Huge Pages File System...
[    5.504194] systemd[1]: Mounted FUSE Control File System.
[    5.508229] systemd[1]: Starting Journal Service...
[    5.521635] systemd[1]: Started Journal Service.
[    5.993202] systemd-journald[82]: Vacuuming done, freed 0 bytes
[    6.683392] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[    6.683400] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    6.683405] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[    6.758967] systemd-udevd[106]: starting version 208
[    6.877103] EXT4-fs (sda2): re-mounted. Opts: data=ordered
[    7.604391] eeepc_laptop: Eee PC Hotkey Driver
[    7.608844] eeepc_laptop: Hotkey init flags 0x41
[    7.629508] eeepc_laptop: TYPE (2000000) not reported by BIOS, enabling anyway
[    7.637497] eeepc_laptop: PANELPOWER (4000000) not reported by BIOS, enabling anyway
[    7.640771] eeepc_laptop: Get control methods supported: 0x6101713
[    7.648356] input: Asus EeePC extra buttons as /devices/platform/eeepc/input/input10
[    7.748007] microcode: CPU0 sig=0x106c2, pf=0x4, revision=0x212
[    7.852852] microcode: CPU1 sig=0x106c2, pf=0x4, revision=0x212
[    7.856432] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.971491] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 2872, rev 0200 detected
[    7.994686] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0003 detected
[    8.024412] systemd-udevd[114]: renamed network interface eth0 to enp3s0
[    8.466114] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
[    8.486484] input: CNF7129 as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input11
[    8.490355] usbcore: registered new interface driver uvcvideo
[    8.494107] USB Video Class driver (1.1.1)
[    8.760779] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    8.936256] systemd-udevd[115]: renamed network interface wlan0 to wlp1s0
[    8.969327] eeepc_laptop: Unable to find port
[    9.279542] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: data=ordered
[    9.357195] systemd-journald[82]: Received request to flush runtime journal from PID 1
[   25.770446] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2860.bin'
[   25.808727] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.34
[   25.856854] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   25.889301] NET: Registered protocol family 17
[   27.721735] wlp1s0: authenticate with 5c:35:3b:41:d6:f6
[   27.736738] wlp1s0: direct probe to 5c:35:3b:41:d6:f6 (try 1/3)
[   27.940114] wlp1s0: direct probe to 5c:35:3b:41:d6:f6 (try 2/3)
[   28.144119] wlp1s0: send auth to 5c:35:3b:41:d6:f6 (try 3/3)
[   28.148494] wlp1s0: authenticated
[   28.152088] wlp1s0: associate with 5c:35:3b:41:d6:f6 (try 1/3)
[   28.155469] wlp1s0: RX AssocResp from 5c:35:3b:41:d6:f6 (capab=0x411 status=0 aid=2)
[   28.155713] IPv6: ADDRCONF(NETDEV_CHANGE): wlp1s0: link becomes ready
[   28.155933] wlp1s0: associated
[   28.407255] [drm:i915_gem_open], 
[   28.407360] [drm:intel_crtc_cursor_set], cursor off
[   28.407367] [drm:intel_crtc_set_config], [CRTC:3] [NOFB]
[   28.407375] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   28.407382] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[   28.407389] [drm:intel_crtc_cursor_set], cursor off
[   28.407395] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[   28.407402] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   28.407408] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[   29.238321] [drm:intel_crtc_set_config], [CRTC:4] [FB:13] #connectors=1 (x y) (0 0)
[   29.238332] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   29.238339] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[   29.251049] [drm:i915_gem_open], 
[   29.251082] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   29.331529] [drm:drm_mode_addfb], [FB:14]
[   29.332596] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   29.332611] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   29.332709] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   29.332722] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   29.333580] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   29.333596] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   30.003509] [drm:drm_mode_addfb], [FB:14]
[   30.003543] [drm:drm_mode_setcrtc], [CRTC:4]
[   30.003561] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[   30.003573] [drm:intel_crtc_set_config], [CRTC:4] [FB:14] #connectors=1 (x y) (0 0)
[   30.003586] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=1
[   30.003597] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[   30.005864] [drm:i915_irq_handler], pipe A underrun
[   30.005923] [drm:i9xx_update_plane], Writing base 00400000 00000000 0 0 4096
[   30.976551] IPv6: ADDRCONF(NETDEV_UP): enp3s0: link is not ready
[   34.194540] wlp1s0: deauthenticating from 5c:35:3b:41:d6:f6 by local choice (reason=2)
[   34.212232] cfg80211: Calling CRDA to update world regulatory domain
[   35.310057] wlp1s0: authenticate with 5c:35:3b:41:d6:f6
[   35.332542] wlp1s0: send auth to 5c:35:3b:41:d6:f6 (try 1/3)
[   35.333965] wlp1s0: authenticated
[   35.336100] wlp1s0: associate with 5c:35:3b:41:d6:f6 (try 1/3)
[   35.339496] wlp1s0: RX AssocResp from 5c:35:3b:41:d6:f6 (capab=0x411 status=0 aid=2)
[   35.339969] wlp1s0: associated
[   35.340446] wlp1s0: deauthenticating from 5c:35:3b:41:d6:f6 by local choice (reason=3)
[   35.368656] cfg80211: Calling CRDA to update world regulatory domain
[   46.456143] wlp1s0: authenticate with 5c:35:3b:41:d6:f6
[   46.472617] wlp1s0: send auth to 5c:35:3b:41:d6:f6 (try 1/3)
[   46.474031] wlp1s0: authenticated
[   46.480074] wlp1s0: associate with 5c:35:3b:41:d6:f6 (try 1/3)
[   46.483479] wlp1s0: RX AssocResp from 5c:35:3b:41:d6:f6 (capab=0x411 status=0 aid=2)
[   46.483733] wlp1s0: associated
[   46.484217] wlp1s0: deauthenticating from 5c:35:3b:41:d6:f6 by local choice (reason=3)
[   46.508726] cfg80211: Calling CRDA to update world regulatory domain
[   48.639269] [drm:intel_crtc_cursor_set], cursor off
[   54.895070] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   54.895131] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   54.908121] [drm:intel_crt_detect], CRT not detected via hotplug
[   54.912171] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   54.912193] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   54.912207] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   54.912223] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   54.912544] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   54.912553] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   54.912560] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   56.185829] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   56.185843] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   56.185851] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   56.185868] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   56.185881] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   56.185895] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   56.186356] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   56.186367] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   56.186376] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   56.200066] [drm:intel_crt_detect], CRT not detected via hotplug
[   56.204075] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   56.204086] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   56.204093] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   56.204101] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   56.204391] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   56.204398] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   56.204405] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   56.204414] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   59.052215] wlp1s0: authenticate with 5c:35:3b:41:d6:f6
[   59.064664] wlp1s0: send auth to 5c:35:3b:41:d6:f6 (try 1/3)
[   59.066071] wlp1s0: authenticated
[   59.068075] wlp1s0: associate with 5c:35:3b:41:d6:f6 (try 1/3)
[   59.072989] wlp1s0: RX AssocResp from 5c:35:3b:41:d6:f6 (capab=0x411 status=0 aid=2)
[   59.073234] wlp1s0: associated
[   59.073492] wlp1s0: deauthenticating from 5c:35:3b:41:d6:f6 by local choice (reason=3)
[   59.096830] cfg80211: Calling CRDA to update world regulatory domain
[   61.161812] [drm:i915_gem_open], 
[   61.559890] [drm:i915_gem_open], 
[   61.563781] [drm:intel_crtc_cursor_set], cursor off
[   61.584754] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   61.584769] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   61.584779] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   61.584795] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   61.584805] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   61.584815] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   61.585313] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   61.585324] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   61.585334] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   61.600056] [drm:intel_crt_detect], CRT not detected via hotplug
[   61.604138] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   61.604157] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   61.604170] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   61.604186] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   61.604507] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   61.604516] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   61.604523] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   61.604533] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   62.792661] [drm:drm_mode_addfb], [FB:15]
[   79.724572] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   79.724700] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   79.724711] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   79.724730] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   79.724744] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   79.724758] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   79.725201] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   79.725213] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   79.725222] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   79.740068] [drm:intel_crt_detect], CRT not detected via hotplug
[   79.744077] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   79.744090] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   79.744097] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   79.744105] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   79.744407] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   79.744416] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   79.744423] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   79.744434] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.118184] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.118200] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.118209] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.118228] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.118241] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.118254] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.118709] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.118723] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.118733] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.132201] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.136069] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.136078] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.136087] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.136094] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.136390] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.136400] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.136407] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.136416] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.141429] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.141445] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.141454] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.141474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.141489] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.141502] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.142112] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.142126] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.142136] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.156100] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.160052] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.160061] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.160066] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.160072] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.160353] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.160358] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.160363] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.160370] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.161777] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.161788] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.161794] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.161809] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.161819] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.161828] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.162112] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.162120] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.162126] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.176166] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.180071] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.180080] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.180086] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.180092] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.180373] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.180378] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.180383] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.180390] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.183721] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.183738] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.183747] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.183765] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.183779] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.183792] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.184277] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.184292] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.184302] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.200089] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.204124] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.204152] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.204160] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.204166] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.204447] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.204453] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.204458] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.204465] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.205748] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.205764] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.205774] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.205793] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.205808] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.205823] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.206273] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.206288] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.206296] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.220103] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.224063] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.224072] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.224077] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.224082] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.224364] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.224369] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.224373] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.224381] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   84.227128] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.227144] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[   84.227153] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[   84.227172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[   84.227186] [drm:drm_mode_debug_printmodeline], Modeline 11:"1024x600" 60 50000 1024 1044 1054 1344 600 602 605 625 0x8 0xa
[   84.227200] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   84.227637] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   84.227650] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   84.227659] [drm:intel_crt_detect], [CONNECTOR:9:VGA-1] force=1
[   84.240101] [drm:intel_crt_detect], CRT not detected via hotplug
[   84.244067] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   84.244076] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.244082] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   84.244087] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   84.244369] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   84.244374] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   84.244379] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   84.244386] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   91.224555] IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
[   92.430255] wlp1s0: authenticate with 5c:35:3b:41:d6:f6
[   92.446759] wlp1s0: send auth to 5c:35:3b:41:d6:f6 (try 1/3)
[   92.448742] wlp1s0: authenticated
[   92.452519] wlp1s0: associate with 5c:35:3b:41:d6:f6 (try 1/3)
[   92.457319] wlp1s0: RX AssocResp from 5c:35:3b:41:d6:f6 (capab=0x411 status=0 aid=2)
[   92.457662] wlp1s0: associated
[   92.457725] IPv6: ADDRCONF(NETDEV_CHANGE): wlp1s0: link becomes ready
[  100.852281] [drm:intel_crtc_cursor_set], cursor off

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="lspci.txt"

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GSE Express Memory Controller Hub [8086:27ac] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GSE Express Integrated Graphics Controller [8086:27ae] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation NM10/ICH7 Family High Definition Audio Controller [8086:27d8] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation NM10/ICH7 Family PCI Express Port 1 [8086:27d0] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation NM10/ICH7 Family PCI Express Port 2 [8086:27d2] (rev 02)
00:1c.3 PCI bridge [0604]: Intel Corporation NM10/ICH7 Family PCI Express Port 4 [8086:27d6] (rev 02)
00:1d.0 USB controller [0c03]: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 [8086:27c8] (rev 02)
00:1d.1 USB controller [0c03]: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 [8086:27c9] (rev 02)
00:1d.2 USB controller [0c03]: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 [8086:27ca] (rev 02)
00:1d.3 USB controller [0c03]: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 [8086:27cb] (rev 02)
00:1d.7 USB controller [0c03]: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller [8086:27cc] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7-M Family) SATA Controller [IDE mode] [8086:27c4] (rev 02)
01:00.0 Network controller [0280]: Ralink corp. RT2790 Wireless 802.11n 1T/2R PCIe [1814:0781]
03:00.0 Ethernet controller [0200]: Qualcomm Atheros AR8121/AR8113/AR8114 Gigabit or Fast Ethernet [1969:1026] (rev b0)

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log"

[    27.608] 
X.Org X Server 1.15.0
Release Date: 2013-12-27
[    27.608] X Protocol Version 11, Revision 0
[    27.608] Build Operating System: Linux 3.12.5-1-ARCH i686 
[    27.608] Current Operating System: Linux Len 3.14.0-1-rc #1 SMP PREEMPT Thu Feb 13 21:20:32 CET 2014 i686
[    27.608] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux-rc root=/dev/sda2 rw drm.debug=0xe log_buf_len=16M native
[    27.608] Build Date: 09 January 2014  09:32:33AM
[    27.608]  
[    27.608] Current version of pixman: 0.32.4
[    27.608] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    27.608] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    27.609] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Feb 13 21:36:28 2014
[    27.813] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    27.813] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    28.154] (==) No Layout section.  Using the first Screen section.
[    28.154] (==) No screen section available. Using defaults.
[    28.155] (**) |-->Screen "Default Screen Section" (0)
[    28.155] (**) |   |-->Monitor "<default monitor>"
[    28.174] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    28.174] (==) Automatically adding devices
[    28.174] (==) Automatically enabling devices
[    28.174] (==) Automatically adding GPU devices
[    28.379] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/100dpi/".
[    28.379] 	Entry deleted from font path.
[    28.379] 	(Run 'mkfontdir' on "/usr/share/fonts/100dpi/").
[    28.380] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/75dpi/".
[    28.380] 	Entry deleted from font path.
[    28.380] 	(Run 'mkfontdir' on "/usr/share/fonts/75dpi/").
[    28.380] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/OTF/,
	/usr/share/fonts/Type1/
[    28.380] (==) ModulePath set to "/usr/lib/xorg/modules"
[    28.380] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    28.406] (II) Loader magic: 0x8265660
[    28.406] (II) Module ABI versions:
[    28.406] 	X.Org ANSI C Emulation: 0.4
[    28.406] 	X.Org Video Driver: 15.0
[    28.406] 	X.Org XInput driver : 20.0
[    28.406] 	X.Org Server Extension : 8.0
[    28.407] (II) xfree86: Adding drm device (/dev/dri/card0)
[    28.410] (--) PCI:*(0:0:2:0) 8086:27ae:1043:8340 rev 3, Mem @ 0xf7f00000/524288, 0xd0000000/268435456, 0xf7ec0000/262144, I/O @ 0x0000dc00/8
[    28.410] (--) PCI: (0:0:2:1) 8086:27a6:1043:8340 rev 3, Mem @ 0xf7f80000/524288
[    28.410] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[    28.425] Initializing built-in extension Generic Event Extension
[    28.425] Initializing built-in extension SHAPE
[    28.425] Initializing built-in extension MIT-SHM
[    28.425] Initializing built-in extension XInputExtension
[    28.426] Initializing built-in extension XTEST
[    28.426] Initializing built-in extension BIG-REQUESTS
[    28.426] Initializing built-in extension SYNC
[    28.426] Initializing built-in extension XKEYBOARD
[    28.426] Initializing built-in extension XC-MISC
[    28.426] Initializing built-in extension SECURITY
[    28.426] Initializing built-in extension XINERAMA
[    28.426] Initializing built-in extension XFIXES
[    28.426] Initializing built-in extension RENDER
[    28.426] Initializing built-in extension RANDR
[    28.426] Initializing built-in extension COMPOSITE
[    28.426] Initializing built-in extension DAMAGE
[    28.426] Initializing built-in extension MIT-SCREEN-SAVER
[    28.426] Initializing built-in extension DOUBLE-BUFFER
[    28.426] Initializing built-in extension RECORD
[    28.426] Initializing built-in extension DPMS
[    28.426] Initializing built-in extension Present
[    28.426] Initializing built-in extension DRI3
[    28.426] Initializing built-in extension X-Resource
[    28.426] Initializing built-in extension XVideo
[    28.426] Initializing built-in extension XVideo-MotionCompensation
[    28.426] Initializing built-in extension XFree86-VidModeExtension
[    28.426] Initializing built-in extension XFree86-DGA
[    28.426] Initializing built-in extension XFree86-DRI
[    28.426] Initializing built-in extension DRI2
[    28.426] (II) "glx" will be loaded by default.
[    28.426] (II) LoadModule: "dri2"
[    28.427] (II) Module "dri2" already built-in
[    28.427] (II) LoadModule: "glamoregl"
[    28.434] (II) Loading /usr/lib/xorg/modules/libglamoregl.so
[    28.914] (II) Module glamoregl: vendor="X.Org Foundation"
[    28.914] 	compiled for 1.15.0, module version = 0.6.0
[    28.914] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    28.914] (II) LoadModule: "glx"
[    28.914] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    29.134] (II) Module glx: vendor="X.Org Foundation"
[    29.134] 	compiled for 1.15.0, module version = 1.0.0
[    29.135] 	ABI class: X.Org Server Extension, version 8.0
[    29.135] (==) AIGLX enabled
[    29.135] Loading extension GLX
[    29.135] (==) Matched intel as autoconfigured driver 0
[    29.135] (==) Matched intel as autoconfigured driver 1
[    29.135] (==) Matched modesetting as autoconfigured driver 2
[    29.135] (==) Matched fbdev as autoconfigured driver 3
[    29.135] (==) Matched vesa as autoconfigured driver 4
[    29.135] (==) Assigned the driver to the xf86ConfigLayout
[    29.135] (II) LoadModule: "intel"
[    29.151] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    29.219] (II) Module intel: vendor="X.Org Foundation"
[    29.219] 	compiled for 1.15.0, module version = 2.99.909
[    29.219] 	Module class: X.Org Video Driver
[    29.219] 	ABI class: X.Org Video Driver, version 15.0
[    29.219] (II) LoadModule: "modesetting"
[    29.221] (WW) Warning, couldn't open module modesetting
[    29.221] (II) UnloadModule: "modesetting"
[    29.221] (II) Unloading modesetting
[    29.221] (EE) Failed to load module "modesetting" (module does not exist, 0)
[    29.221] (II) LoadModule: "fbdev"
[    29.222] (WW) Warning, couldn't open module fbdev
[    29.222] (II) UnloadModule: "fbdev"
[    29.222] (II) Unloading fbdev
[    29.222] (EE) Failed to load module "fbdev" (module does not exist, 0)
[    29.222] (II) LoadModule: "vesa"
[    29.223] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    29.233] (II) Module vesa: vendor="X.Org Foundation"
[    29.233] 	compiled for 1.15.0, module version = 2.3.2
[    29.233] 	Module class: X.Org Video Driver
[    29.234] 	ABI class: X.Org Video Driver, version 15.0
[    29.234] (II) intel: Driver for Intel(R) Integrated Graphics Chipsets:
	i810, i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G,
	915G, E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM,
	Pineview G, 965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33,
	GM45, 4 Series, G45/G43, Q45/Q43, G41, B43
[    29.236] (II) intel: Driver for Intel(R) HD Graphics: 2000-5000
[    29.236] (II) intel: Driver for Intel(R) Iris(TM) Graphics: 5100
[    29.236] (II) intel: Driver for Intel(R) Iris(TM) Pro Graphics: 5200
[    29.236] (II) VESA: driver for VESA chipsets: vesa
[    29.236] (++) using VT number 7

[    29.297] (WW) Falling back to old probe method for vesa
[    29.331] (--) intel(0): Integrated Graphics Chipset: Intel(R) 945GME
[    29.331] (--) intel(0): CPU: x86, sse2, sse3, ssse3
[    29.331] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    29.331] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    29.331] (==) intel(0): RGB weight 888
[    29.331] (==) intel(0): Default visual is TrueColor
[    29.332] (**) intel(0): Framebuffer tiled
[    29.332] (**) intel(0): Pixmaps tiled
[    29.332] (**) intel(0): "Tear free" disabled
[    29.332] (**) intel(0): Forcing per-crtc-pixmaps? no
[    29.332] (II) intel(0): Output LVDS1 has no monitor section
[    29.333] (--) intel(0): found backlight control interface eeepc (type 'platform')
[    29.333] (II) intel(0): Output VGA1 has no monitor section
[    29.333] (II) intel(0): Output VIRTUAL1 has no monitor section
[    29.333] (--) intel(0): Output LVDS1 using initial mode 1024x600 on pipe 1
[    29.333] (==) intel(0): DPI set to (96, 96)
[    29.333] (II) Loading sub module "dri2"
[    29.333] (II) LoadModule: "dri2"
[    29.333] (II) Module "dri2" already built-in
[    29.333] (II) UnloadModule: "vesa"
[    29.334] (II) Unloading vesa
[    29.334] (==) Depth 24 pixmap format is 32 bpp
[    29.442] (II) intel(0): SNA initialized with Alviso (gen3) backend
[    29.442] (==) intel(0): Backing store enabled
[    29.442] (==) intel(0): Silken mouse enabled
[    29.455] (II) intel(0): HW Cursor enabled
[    29.455] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    29.462] (==) intel(0): DPMS enabled
[    29.480] (II) intel(0): [XvMC] i915_xvmc driver initialized.
[    29.481] (II) intel(0): [DRI2] Setup complete
[    29.481] (II) intel(0): [DRI2]   DRI driver: i915
[    29.481] (II) intel(0): [DRI2]   VDPAU driver: i915
[    29.481] (II) intel(0): direct rendering: DRI2 Enabled
[    29.481] (==) intel(0): hotplug detection: "enabled"
[    29.481] (--) RandR disabled
[    29.994] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    29.994] (II) AIGLX: enabled GLX_ARB_create_context
[    29.994] (II) AIGLX: enabled GLX_ARB_create_context_profile
[    29.994] (II) AIGLX: enabled GLX_EXT_create_context_es2_profile
[    29.994] (II) AIGLX: enabled GLX_INTEL_swap_event
[    29.994] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    29.994] (II) AIGLX: enabled GLX_EXT_framebuffer_sRGB
[    29.995] (II) AIGLX: enabled GLX_ARB_fbconfig_float
[    29.995] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    29.995] (II) AIGLX: Loaded and initialized i915
[    29.995] (II) GLX: Initialized DRI2 GL provider for screen 0
[    30.003] (II) intel(0): switch to mode 1024x600@59.5 on LVDS1 using pipe 1, position (0, 0), rotation normal, reflection none
[    30.016] (II) intel(0): Setting screen physical size to 270 x 158
[    30.667] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[    30.667] (**) Power Button: Applying InputClass "system-keyboard"
[    30.667] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    30.667] (II) LoadModule: "evdev"
[    30.668] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    30.691] (II) Module evdev: vendor="X.Org Foundation"
[    30.691] 	compiled for 1.15.0, module version = 2.8.2
[    30.691] 	Module class: X.Org XInput Driver
[    30.691] 	ABI class: X.Org XInput driver, version 20.0
[    30.691] (II) Using input driver 'evdev' for 'Power Button'
[    30.691] (**) Power Button: always reports core events
[    30.691] (**) evdev: Power Button: Device: "/dev/input/event3"
[    30.691] (--) evdev: Power Button: Vendor 0 Product 0x1
[    30.691] (--) evdev: Power Button: Found keys
[    30.691] (II) evdev: Power Button: Configuring as keyboard
[    30.691] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[    30.691] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[    30.691] (**) Option "xkb_rules" "evdev"
[    30.691] (**) Option "xkb_model" "pc105"
[    30.691] (**) Option "xkb_layout" "es"
[    30.691] (**) Option "xkb_variant" "qwerty"
[    30.691] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.763] (EE) Error loading keymap /var/lib/xkb/server-0.xkm
[    30.763] (EE) XKB: Failed to load keymap. Loading default keymap instead.
[    30.849] (II) config/udev: Adding input device Video Bus (/dev/input/event4)
[    30.849] (**) Video Bus: Applying InputClass "system-keyboard"
[    30.849] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    30.849] (II) Using input driver 'evdev' for 'Video Bus'
[    30.850] (**) Video Bus: always reports core events
[    30.850] (**) evdev: Video Bus: Device: "/dev/input/event4"
[    30.850] (--) evdev: Video Bus: Vendor 0 Product 0x6
[    30.850] (--) evdev: Video Bus: Found keys
[    30.850] (II) evdev: Video Bus: Configuring as keyboard
[    30.850] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4/event4"
[    30.850] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[    30.850] (**) Option "xkb_rules" "evdev"
[    30.850] (**) Option "xkb_model" "pc105"
[    30.850] (**) Option "xkb_layout" "es"
[    30.850] (**) Option "xkb_variant" "qwerty"
[    30.850] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.851] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    30.851] (**) Power Button: Applying InputClass "system-keyboard"
[    30.852] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    30.852] (II) Using input driver 'evdev' for 'Power Button'
[    30.852] (**) Power Button: always reports core events
[    30.852] (**) evdev: Power Button: Device: "/dev/input/event2"
[    30.852] (--) evdev: Power Button: Vendor 0 Product 0x1
[    30.852] (--) evdev: Power Button: Found keys
[    30.852] (II) evdev: Power Button: Configuring as keyboard
[    30.852] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    30.852] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 8)
[    30.852] (**) Option "xkb_rules" "evdev"
[    30.852] (**) Option "xkb_model" "pc105"
[    30.852] (**) Option "xkb_layout" "es"
[    30.852] (**) Option "xkb_variant" "qwerty"
[    30.852] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.854] (II) config/udev: Adding input device Lid Switch (/dev/input/event0)
[    30.854] (II) No input driver specified, ignoring this device.
[    30.854] (II) This device may have been added with another device file.
[    30.854] (II) config/udev: Adding input device Sleep Button (/dev/input/event1)
[    30.854] (**) Sleep Button: Applying InputClass "system-keyboard"
[    30.854] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    30.854] (II) Using input driver 'evdev' for 'Sleep Button'
[    30.855] (**) Sleep Button: always reports core events
[    30.855] (**) evdev: Sleep Button: Device: "/dev/input/event1"
[    30.855] (--) evdev: Sleep Button: Vendor 0 Product 0x3
[    30.855] (--) evdev: Sleep Button: Found keys
[    30.855] (II) evdev: Sleep Button: Configuring as keyboard
[    30.855] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1/event1"
[    30.855] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD, id 9)
[    30.855] (**) Option "xkb_rules" "evdev"
[    30.855] (**) Option "xkb_model" "pc105"
[    30.855] (**) Option "xkb_layout" "es"
[    30.855] (**) Option "xkb_variant" "qwerty"
[    30.855] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.856] (II) config/udev: Adding drm device (/dev/dri/card0)
[    30.857] (II) config/udev: Adding input device HDA Intel Mic (/dev/input/event7)
[    30.857] (II) No input driver specified, ignoring this device.
[    30.857] (II) This device may have been added with another device file.
[    30.858] (II) config/udev: Adding input device HDA Intel Headphone (/dev/input/event6)
[    30.858] (II) No input driver specified, ignoring this device.
[    30.858] (II) This device may have been added with another device file.
[    30.859] (II) config/udev: Adding input device CNF7129 (/dev/input/event10)
[    30.859] (**) CNF7129: Applying InputClass "system-keyboard"
[    30.859] (**) CNF7129: Applying InputClass "evdev keyboard catchall"
[    30.859] (II) Using input driver 'evdev' for 'CNF7129'
[    30.859] (**) CNF7129: always reports core events
[    30.859] (**) evdev: CNF7129: Device: "/dev/input/event10"
[    30.859] (--) evdev: CNF7129: Vendor 0x4f2 Product 0xb071
[    30.859] (--) evdev: CNF7129: Found keys
[    30.859] (II) evdev: CNF7129: Configuring as keyboard
[    30.859] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input11/event10"
[    30.859] (II) XINPUT: Adding extended input device "CNF7129" (type: KEYBOARD, id 10)
[    30.859] (**) Option "xkb_rules" "evdev"
[    30.859] (**) Option "xkb_model" "pc105"
[    30.859] (**) Option "xkb_layout" "es"
[    30.859] (**) Option "xkb_variant" "qwerty"
[    30.859] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.861] (II) config/udev: Adding input device Asus EeePC extra buttons (/dev/input/event9)
[    30.861] (**) Asus EeePC extra buttons: Applying InputClass "system-keyboard"
[    30.861] (**) Asus EeePC extra buttons: Applying InputClass "evdev keyboard catchall"
[    30.861] (II) Using input driver 'evdev' for 'Asus EeePC extra buttons'
[    30.862] (**) Asus EeePC extra buttons: always reports core events
[    30.862] (**) evdev: Asus EeePC extra buttons: Device: "/dev/input/event9"
[    30.862] (--) evdev: Asus EeePC extra buttons: Vendor 0 Product 0
[    30.862] (--) evdev: Asus EeePC extra buttons: Found keys
[    30.862] (II) evdev: Asus EeePC extra buttons: Configuring as keyboard
[    30.862] (**) Option "config_info" "udev:/sys/devices/platform/eeepc/input/input10/event9"
[    30.862] (II) XINPUT: Adding extended input device "Asus EeePC extra buttons" (type: KEYBOARD, id 11)
[    30.862] (**) Option "xkb_rules" "evdev"
[    30.862] (**) Option "xkb_model" "pc105"
[    30.862] (**) Option "xkb_layout" "es"
[    30.862] (**) Option "xkb_variant" "qwerty"
[    30.862] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.863] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event5)
[    30.864] (**) AT Translated Set 2 keyboard: Applying InputClass "system-keyboard"
[    30.864] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    30.864] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    30.864] (**) AT Translated Set 2 keyboard: always reports core events
[    30.864] (**) evdev: AT Translated Set 2 keyboard: Device: "/dev/input/event5"
[    30.864] (--) evdev: AT Translated Set 2 keyboard: Vendor 0x1 Product 0x1
[    30.864] (--) evdev: AT Translated Set 2 keyboard: Found keys
[    30.864] (II) evdev: AT Translated Set 2 keyboard: Configuring as keyboard
[    30.864] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input5/event5"
[    30.864] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 12)
[    30.864] (**) Option "xkb_rules" "evdev"
[    30.864] (**) Option "xkb_model" "pc105"
[    30.864] (**) Option "xkb_layout" "es"
[    30.864] (**) Option "xkb_variant" "qwerty"
[    30.864] (**) Option "xkb_options" "terminate:ctrl_alt_bksp"
[    30.866] (II) config/udev: Adding input device ETPS/2 Elantech Touchpad (/dev/input/event8)
[    30.866] (**) ETPS/2 Elantech Touchpad: Applying InputClass "evdev touchpad catchall"
[    30.866] (**) ETPS/2 Elantech Touchpad: Applying InputClass "touchpad catchall"
[    30.866] (**) ETPS/2 Elantech Touchpad: Applying InputClass "Default clickpad buttons"
[    30.866] (**) ETPS/2 Elantech Touchpad: Applying InputClass "touchpad catchall"
[    30.866] (**) ETPS/2 Elantech Touchpad: Applying InputClass "Default clickpad buttons"
[    30.866] (II) LoadModule: "synaptics"
[    30.866] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    30.937] (II) Module synaptics: vendor="X.Org Foundation"
[    30.937] 	compiled for 1.15.0, module version = 1.7.3
[    30.937] 	Module class: X.Org XInput Driver
[    30.937] 	ABI class: X.Org XInput driver, version 20.0
[    30.937] (II) Using input driver 'synaptics' for 'ETPS/2 Elantech Touchpad'
[    30.937] (**) ETPS/2 Elantech Touchpad: always reports core events
[    30.937] (**) Option "Device" "/dev/input/event8"
[    31.000] (II) synaptics: ETPS/2 Elantech Touchpad: ignoring touch events for semi-multitouch device
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: x-axis range 0 - 1152 (res 0)
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: y-axis range 0 - 768 (res 0)
[    31.000] (II) synaptics: ETPS/2 Elantech Touchpad: device does not report pressure, will use touch data.
[    31.000] (II) synaptics: ETPS/2 Elantech Touchpad: device does not report finger width.
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: buttons: left right double triple
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: Vendor 0x2 Product 0xe
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: invalid pressure range.  defaulting to 0 - 255
[    31.000] (--) synaptics: ETPS/2 Elantech Touchpad: invalid finger width range.  defaulting to 0 - 15
[    31.001] (**) Option "HorizTwoFingerScroll" "1"
[    31.001] (**) Option "TapButton1" "1"
[    31.001] (**) Option "TapButton2" "3"
[    31.001] (**) Option "TapButton3" "2"
[    31.001] (--) synaptics: ETPS/2 Elantech Touchpad: touchpad found
[    31.001] (**) ETPS/2 Elantech Touchpad: always reports core events
[    31.032] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input9/event8"
[    31.032] (II) XINPUT: Adding extended input device "ETPS/2 Elantech Touchpad" (type: TOUCHPAD, id 13)
[    31.032] (**) synaptics: ETPS/2 Elantech Touchpad: (accel) MinSpeed is now constant deceleration 2.5
[    31.032] (**) synaptics: ETPS/2 Elantech Touchpad: (accel) MaxSpeed is now 1.75
[    31.032] (**) synaptics: ETPS/2 Elantech Touchpad: (accel) AccelFactor is now 0.145
[    31.033] (**) ETPS/2 Elantech Touchpad: (accel) keeping acceleration scheme 1
[    31.033] (**) ETPS/2 Elantech Touchpad: (accel) acceleration profile 1
[    31.033] (**) ETPS/2 Elantech Touchpad: (accel) acceleration factor: 2.000
[    31.033] (**) ETPS/2 Elantech Touchpad: (accel) acceleration threshold: 4
[    31.033] (--) synaptics: ETPS/2 Elantech Touchpad: touchpad found
[    31.034] (II) config/udev: Adding input device ETPS/2 Elantech Touchpad (/dev/input/mouse0)
[    31.034] (**) ETPS/2 Elantech Touchpad: Ignoring device from InputClass "touchpad ignore duplicates"

--1yeeQ81UyVL57Vl7--
