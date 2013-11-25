Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3KYJlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:41:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:44495 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3KYJk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:40:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,766,1378882800"; 
   d="scan'208";a="414128781"
Date: Mon, 25 Nov 2013 11:47:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to
 pci_destroy_dev()
Message-ID: <20131125094707.GR2281@intel.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <4668705.kv8hgxjqAc@vostro.rjw.lan>
 <20131123230701.GA6183@kroah.com>
 <53283503.VcSP9RLiFc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53283503.VcSP9RLiFc@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 01:17:52AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
> I'm seeing traces analogous to the one below in Thunderbolt testing:
> 
> WARNING: CPU: 3 PID: 76 at /scratch/rafael/work/linux-pm/fs/sysfs/group.c:214 sysfs_remove_group+0x59/0xe0()
>  sysfs group ffffffff81c6c500 not found for kobject '0000:08'
>  Modules linked in: fuse hidp af_packet xt_tcpudp xt_pkttype xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack rfcomm ip6table_filter bnep ip6_tables x_tables arc4 ath9k mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul iTCO_wdt crc32c_intel iTCO_vendor_support ghash_clmulni_intel aesni_intel ablk_helper acer_wmi sparse_keymap ath9k_common ath9k_hw cryptd lrw gf128mul ath3k glue_helper aes_x86_64 btusb microcode ath pcspkr joydev uvcvideo serio_raw videobuf2_core i2c_i801 videodev snd_hda_codec_hdmi cfg80211 videobuf2_vmalloc tg3 videobuf2_memops sg ptp pps_core lpc_ich mfd_core snd_hda_codec_realtek bluetooth hid_logitech_dj rfkill snd_hda_intel snd_hda_codec shpchp battery ac wmi acpi_cpufreq edd snd_usb_audio snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib 
> snd_rawmidi snd_seq snd_timer snd_seq_device snd soundcore autofs4 xhci_hcd processor scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_dh
>  CPU: 3 PID: 76 Comm: kworker/u16:7 Not tainted 3.13.0-rc1+ #76
>  Hardware name: Acer Aspire S5-391/Venus    , BIOS V1.02 05/29/2012
>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>   0000000000000009 ffff8801644b9ac8 ffffffff816b23bf 0000000000000007
>   ffff8801644b9b18 ffff8801644b9b08 ffffffff81046607 ffff88016925b800
>   0000000000000000 ffffffff81c6c500 ffff88016924f928 ffff88016924f800
>  Call Trace:
>   [<ffffffff816b23bf>] dump_stack+0x4e/0x71
>   [<ffffffff81046607>] warn_slowpath_common+0x87/0xb0
>   [<ffffffff810466d1>] warn_slowpath_fmt+0x41/0x50
>   [<ffffffff811e42ef>] ? sysfs_get_dirent_ns+0x6f/0x80
>   [<ffffffff811e5389>] sysfs_remove_group+0x59/0xe0
>   [<ffffffff8149f00b>] dpm_sysfs_remove+0x3b/0x50
>   [<ffffffff81495818>] device_del+0x58/0x1c0
>   [<ffffffff814959c8>] device_unregister+0x48/0x60
>   [<ffffffff813254fe>] pci_remove_bus+0x6e/0x80
>   [<ffffffff81325548>] pci_remove_bus_device+0x38/0x110
>   [<ffffffff8132555d>] pci_remove_bus_device+0x4d/0x110
>   [<ffffffff81325639>] pci_stop_and_remove_bus_device+0x19/0x20
>   [<ffffffff813418d0>] disable_slot+0x20/0xe0
>   [<ffffffff81341a38>] acpiphp_check_bridge+0xa8/0xd0
>   [<ffffffff813427ad>] hotplug_event+0x17d/0x220
>   [<ffffffff81342880>] hotplug_event_work+0x30/0x70
>   [<ffffffff8136d665>] acpi_hotplug_work_fn+0x18/0x24
>   [<ffffffff81061331>] process_one_work+0x261/0x450
>   [<ffffffff81061a7e>] worker_thread+0x21e/0x370
>   [<ffffffff81061860>] ? rescuer_thread+0x300/0x300
>   [<ffffffff81068342>] kthread+0xd2/0xe0
>   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
>   [<ffffffff816c19bc>] ret_from_fork+0x7c/0xb0
>   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
> 
> (Mika Westerberg sees them too in his tests).
> 
> Some investigation documented in kernel bug #65281 lead me to the
> conclusion that the source of the problem is the device_del() in
> pci_stop_dev() as it now causes the sysfs directory of the device
> to be removed recursively along with all of its subdirectories.
> That includes the sysfs directory of the device's subordinate
> bus (dev->subordinate) and its "power" group.
> 
> Consequently, when pci_remove_bus() is called for dev->subordinate
> in pci_remove_bus_device(), it calls device_unregister(&bus->dev),
> but at this point the sysfs directory of bus->dev doesn't exist any
> more and its "power" group doesn't exist either.  Thus, when
> dpm_sysfs_remove() called from device_del() tries to remove that
> group, it triggers the above warning.
> 
> That indicates a logical mistake in the design of
> pci_stop_and_remove_bus_device(), which causes bus device objects
> to be left behind their parents (bridge device objects) and can be
> fixed by moving the device_del() from pci_stop_dev() into
> pci_destroy_dev(), so pci_remove_bus() can be called for the
> device's subordinate bus before the device itself is unregistered
> from the hierarchy.  Still, the driver, if any, should be detached
> from the device in pci_stop_dev(), so use device_release_driver()
> directly from there.

With only this patch applied, I can still see the warnings :-/ I'm going to
test the ata fix you proposed soon.

Here's the whole dmesg taken from Intel NUC after TBT hot-unplug:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-rc1+ (westeri@blue) (gcc version 4.8.2 (Debian 4.8.2-5) ) #49 SMP Mon Nov 25 11:30:53 EET 2013
[    0.000000] Command line: console=tty1 buildroot_hostname=nuc loglevel=10 acpiphp.dyndbg=+p
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x0000000074fd8fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000074fd9000-0x00000000752fdfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000752fe000-0x000000007530dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007530e000-0x0000000075423fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000075424000-0x000000007569bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007569c000-0x000000007569cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007569d000-0x00000000756dffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000756e0000-0x0000000075ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076800000-0x000000007e9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001005fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x100600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FFFC00000 write-back
[    0.000000]   2 base 100400000 mask FFFE00000 write-back
[    0.000000]   3 base 080000000 mask F80000000 uncachable
[    0.000000]   4 base 078000000 mask FF8000000 uncachable
[    0.000000]   5 base 077000000 mask FFF000000 uncachable
[    0.000000]   6 base 076800000 mask FFF800000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0x76800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x76000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd700-0x000fd70f] mapped at [ffff8800000fd700]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x020f3000, 0x020f3fff] PGTABLE
[    0.000000] BRK [0x020f4000, 0x020f4fff] PGTABLE
[    0.000000] BRK [0x020f5000, 0x020f5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100400000-0x1005fffff]
[    0.000000]  [mem 0x100400000-0x1005fffff] page 2M
[    0.000000] BRK [0x020f6000, 0x020f6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1003fffff]
[    0.000000]  [mem 0x100000000-0x1003fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x020f7000, 0x020f7fff] PGTABLE
[    0.000000] BRK [0x020f8000, 0x020f8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0x74fd8fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0x74dfffff] page 2M
[    0.000000]  [mem 0x74e00000-0x74fd8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7569c000-0x7569cfff]
[    0.000000]  [mem 0x7569c000-0x7569cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x756e0000-0x75ffffff]
[    0.000000]  [mem 0x756e0000-0x757fffff] page 4k
[    0.000000]  [mem 0x75800000-0x75ffffff] page 2M
[    0.000000] RAMDISK: [mem 0x75bd8000-0x75ff5fff]
[    0.000000] ACPI: RSDP 00000000000f0490 000024 (v02  INTEL)
[    0.000000] ACPI: XSDT 0000000075303070 000064 (v01  Intel D33217CK 0000002A AMI  00010013)
[    0.000000] ACPI: FACP 000000007530c6a0 00010C (v05  Intel D33217CK 0000002A AMI  00010013)
[    0.000000] ACPI: DSDT 0000000075303168 009532 (v02  Intel D33217CK 0000002A INTL 20051117)
[    0.000000] ACPI: FACS 0000000075422080 000040
[    0.000000] ACPI: APIC 000000007530c7b0 000072 (v03  Intel D33217CK 0000002A AMI  00010013)
[    0.000000] ACPI: FPDT 000000007530c828 000044 (v01  Intel D33217CK 0000002A AMI  00010013)
[    0.000000] ACPI: MCFG 000000007530c870 00003C (v01  Intel D33217CK 0000002A MSFT 00000097)
[    0.000000] ACPI: HPET 000000007530c8b0 000038 (v01  Intel D33217CK 0000002A AMI. 00000005)
[    0.000000] ACPI: SSDT 000000007530c8e8 000315 (v01  Intel D33217CK 0000002A INTL 20091112)
[    0.000000] ACPI: SSDT 000000007530cc00 0008A2 (v01  Intel D33217CK 0000002A INTL 20051117)
[    0.000000] ACPI: SSDT 000000007530d4a8 000A92 (v01  Intel D33217CK 0000002A INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001005fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1005fffff]
[    0.000000]   NODE_DATA [mem 0x1005fa000-0x1005fdfff]
[    0.000000]  [ffffea0000000000-ffffea00041fffff] PMD -> [ffff880072e00000-ffff880074dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1005fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0x74fd8fff]
[    0.000000]   node   0: [mem 0x7569c000-0x7569cfff]
[    0.000000]   node   0: [mem 0x756e0000-0x75ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x1005fffff]
[    0.000000] On node 0 totalpages: 482454
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7452 pages used for memmap
[    0.000000]   DMA32 zone: 476921 pages, LIFO batch:31
[    0.000000]   Normal zone: 24 pages used for memmap
[    0.000000]   Normal zone: 1536 pages, LIFO batch:0
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0x74fd9000-0x752fdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x752fe000-0x7530dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7530e000-0x75423fff]
[    0.000000] PM: Registered nosave memory: [mem 0x75424000-0x7569bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7569d000-0x756dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76000000-0x767fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76800000-0x7e9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ea00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x7ea00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880100200000 s79424 r8192 d22976 u524288
[    0.000000] pcpu-alloc: s79424 r8192 d22976 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 474893
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=tty1 buildroot_hostname=nuc loglevel=10 acpiphp.dyndbg=+p
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1808800K/1929816K available (8322K kernel code, 903K rwdata, 2820K rodata, 1064K init, 1012K bss, 121016K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty1] enabled
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 1797.685 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3595.37 BogoMIPS (lpj=1797685)
[    0.000008] pid_max: default: 32768 minimum: 301
[    0.000033] Security Framework initialized
[    0.000041] SELinux:  Initializing.
[    0.000050] SELinux:  Starting in permissive mode
[    0.000239] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000975] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001300] Mount-cache hash table entries: 256
[    0.001519] Initializing cgroup subsys freezer
[    0.001547] CPU: Physical Processor ID: 0
[    0.001549] CPU: Processor Core ID: 1
[    0.001557] mce: CPU supports 7 MCE banks
[    0.001569] CPU0: Thermal LVT vector (0xfa) already installed
[    0.001579] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.001579] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.001579] tlb_flushall_shift: 1
[    0.001764] Freeing SMP alternatives memory: 28K (ffffffff81fed000 - ffffffff81ff4000)
[    0.001769] ACPI: Core revision 20130927
[    0.009936] ACPI: All ACPI Tables successfully acquired
[    0.010452] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.020464] smpboot: CPU0: Intel(R) Core(TM) i3-3217U CPU @ 1.80GHz (fam: 06, model: 3a, stepping: 09)
[    0.020477] TSC deadline timer enabled
[    0.020487] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.020498] ... version:                3
[    0.020501] ... bit width:              48
[    0.020503] ... generic registers:      4
[    0.020505] ... value mask:             0000ffffffffffff
[    0.020507] ... max period:             0000ffffffffffff
[    0.020509] ... fixed-purpose events:   3
[    0.020511] ... event mask:             000000070000000f
[    0.021323] x86: Booting SMP configuration:
[    0.032381] CPU1: Thermal LVT vector (0xfa) already installed
[    0.045738] CPU2: Thermal LVT vector (0xfa) already installed
[    0.059076] CPU3: Thermal LVT vector (0xfa) already installed
[    0.021327] .... node  #0, CPUs:      #1 #2 #3
[    0.061180] x86: Booted up 1 node, 4 CPUs
[    0.061188] smpboot: Total of 4 processors activated (14381.48 BogoMIPS)
[    0.064970] devtmpfs: initialized
[    0.065195] PM: Registering ACPI NVS region [mem 0x7530e000-0x75423fff] (1138688 bytes)
[    0.065218] PM: Registering ACPI NVS region [mem 0x7569d000-0x756dffff] (274432 bytes)
[    0.065316] kworker/u8:0 (26) used greatest stack depth: 5936 bytes left
[    0.065483] RTC time: 17:26:57, date: 11/25/13
[    0.065527] NET: Registered protocol family 16
[    0.065947] cpuidle: using governor ladder
[    0.065953] cpuidle: using governor menu
[    0.066006] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.066010] ACPI: bus type PCI registered
[    0.066013] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.066105] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.066111] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.075476] PCI: Using configuration type 1 for base access
[    0.076403] kworker/u8:0 (69) used greatest stack depth: 5848 bytes left
[    0.085708] bio: create slab <bio-0> at 0
[    0.085897] ACPI: Added _OSI(Module Device)
[    0.085903] ACPI: Added _OSI(Processor Device)
[    0.085908] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.085912] ACPI: Added _OSI(Processor Aggregator Device)
[    0.089696] ACPI: Executed 1 blocks of module-level executable AML code
[    0.098611] ACPI: SSDT 00000000752ab018 00083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.099099] ACPI: Dynamic OEM Table Load:
[    0.099103] ACPI: SSDT           (null) 00083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.104301] ACPI: SSDT 00000000752aca98 000303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.104831] ACPI: Dynamic OEM Table Load:
[    0.104834] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.107018] ACPI: SSDT 00000000752adc18 000119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.107472] ACPI: Dynamic OEM Table Load:
[    0.107476] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.110848] ACPI: Interpreter enabled
[    0.110863] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130927/hwxface-580)
[    0.110883] ACPI: (supports S0 S1 S3 S4 S5)
[    0.110886] ACPI: Using IOAPIC for interrupt routing
[    0.110968] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.111222] ACPI: No dock devices found.
[    0.124988] ACPI: Power Resource [FN00] (off)
[    0.125172] ACPI: Power Resource [FN01] (off)
[    0.125350] ACPI: Power Resource [FN02] (off)
[    0.125523] ACPI: Power Resource [FN03] (off)
[    0.125696] ACPI: Power Resource [FN04] (off)
[    0.126800] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.126811] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.127140] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.127410] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.128449] ACPI: \_SB_.PCI0.TPMX: can't evaluate _ADR (0x5)
[    0.128714] ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
[    0.128718] ACPI: \_SB_.PCI0.DOCK: can't evaluate _ADR (0x5)
[    0.128721] PCI host bridge to bus 0000:00
[    0.128726] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.128729] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.128732] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.128736] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.128739] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.128742] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.128745] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.128749] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.128752] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.128755] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.128758] pci_bus 0000:00: root bus resource [mem 0x7ea00000-0xfeafffff]
[    0.128762] pci_bus 0000:00: scanning bus
[    0.128773] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.128785] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.128942] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.128964] pci 0000:00:02.0: reg 0x10: [mem 0xf6400000-0xf67fffff 64bit]
[    0.128974] pci 0000:00:02.0: reg 0x18: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.128982] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.129161] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.129193] pci 0000:00:16.0: reg 0x10: [mem 0xf680b000-0xf680b00f 64bit]
[    0.129280] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.129287] pci 0000:00:16.0: PME# disabled
[    0.129437] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.129465] pci 0000:00:1a.0: reg 0x10: [mem 0xf6808000-0xf68083ff]
[    0.129569] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.129576] pci 0000:00:1a.0: PME# disabled
[    0.129685] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.129758] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.129782] pci 0000:00:1b.0: reg 0x10: [mem 0xf6800000-0xf6803fff 64bit]
[    0.129863] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.129869] pci 0000:00:1b.0: PME# disabled
[    0.129951] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.130050] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.130121] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    0.130196] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.130203] pci 0000:00:1c.0: PME# disabled
[    0.130293] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.130366] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.130431] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x30
[    0.130504] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.130511] pci 0000:00:1c.4: PME# disabled
[    0.130599] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.130671] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.130700] pci 0000:00:1d.0: reg 0x10: [mem 0xf6807000-0xf68073ff]
[    0.130804] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.130811] pci 0000:00:1d.0: PME# disabled
[    0.130921] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.130992] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    0.131250] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.131278] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.131289] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.131300] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.131311] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.131323] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.131335] pci 0000:00:1f.2: reg 0x24: [mem 0xf6806000-0xf68067ff]
[    0.131390] pci 0000:00:1f.2: PME# supported from D3hot
[    0.131395] pci 0000:00:1f.2: PME# disabled
[    0.131527] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.131551] pci 0000:00:1f.3: reg 0x10: [mem 0xf6805000-0xf68050ff 64bit]
[    0.131577] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.131722] pci_bus 0000:00: fixups for bus
[    0.131729] pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 0
[    0.131850] pci_bus 0000:01: scanning bus
[    0.131858] pci_bus 0000:01: fixups for bus
[    0.131861] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.131881] pci_bus 0000:01: bus scan returning with max=01
[    0.131889] pci 0000:00:1c.4: scanning [bus 02-3a] behind bridge, pass 0
[    0.132041] pci_bus 0000:02: scanning bus
[    0.132049] pci_bus 0000:02: fixups for bus
[    0.132051] pci 0000:00:1c.4: PCI bridge to [bus 02-3a]
[    0.132058] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
[    0.132065] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xf60fffff]
[    0.132075] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xd1ffffff 64bit pref]
[    0.132079] pci_bus 0000:02: bus scan returning with max=02
[    0.132090] pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 1
[    0.132101] pci 0000:00:1c.4: scanning [bus 02-3a] behind bridge, pass 1
[    0.132110] pci_bus 0000:00: bus scan returning with max=3a
[    0.132113] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.132753] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    0.132862] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.132966] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    0.133079] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    0.133183] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.133288] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.133394] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    0.133496] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 10 11 12 14 15), disabled.
[    0.133839] ACPI: Enabled 7 GPEs in block 00 to 3F
[    0.133851] ACPI: \_SB_.PCI0: notify handler is installed
[    0.133931] Found 1 acpi root devices
[    0.134119] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.134125] vgaarb: loaded
[    0.134127] vgaarb: bridge control possible 0000:00:02.0
[    0.134270] SCSI subsystem initialized
[    0.134394] libata version 3.00 loaded.
[    0.134511] ACPI: bus type USB registered
[    0.134577] usbcore: registered new interface driver usbfs
[    0.134614] usbcore: registered new interface driver hub
[    0.134664] usbcore: registered new device driver usb
[    0.134780] pps_core: LinuxPPS API ver. 1 registered
[    0.134783] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.134811] PTP clock support registered
[    0.134985] Advanced Linux Sound Architecture Driver Initialized.
[    0.134989] PCI: Using ACPI for IRQ routing
[    0.138251] PCI: pci_cache_line_size set to 64 bytes
[    0.138260] pci 0000:00:02.0: BAR 0: reserving [mem 0xf6400000-0xf67fffff flags 0x140204] (d=0, p=0)
[    0.138265] pci 0000:00:02.0: BAR 2: reserving [mem 0xa0000000-0xafffffff flags 0x14220c] (d=0, p=0)
[    0.138270] pci 0000:00:02.0: BAR 4: reserving [io  0xf000-0xf03f flags 0x40101] (d=0, p=0)
[    0.138279] pci 0000:00:16.0: BAR 0: reserving [mem 0xf680b000-0xf680b00f flags 0x140204] (d=0, p=0)
[    0.138288] pci 0000:00:1a.0: BAR 0: reserving [mem 0xf6808000-0xf68083ff flags 0x40200] (d=0, p=0)
[    0.138296] pci 0000:00:1b.0: BAR 0: reserving [mem 0xf6800000-0xf6803fff flags 0x140204] (d=0, p=0)
[    0.138308] pci 0000:00:1d.0: BAR 0: reserving [mem 0xf6807000-0xf68073ff flags 0x40200] (d=0, p=0)
[    0.138318] pci 0000:00:1f.2: BAR 0: reserving [io  0xf0b0-0xf0b7 flags 0x40101] (d=0, p=0)
[    0.138322] pci 0000:00:1f.2: BAR 1: reserving [io  0xf0a0-0xf0a3 flags 0x40101] (d=0, p=0)
[    0.138326] pci 0000:00:1f.2: BAR 2: reserving [io  0xf090-0xf097 flags 0x40101] (d=0, p=0)
[    0.138330] pci 0000:00:1f.2: BAR 3: reserving [io  0xf080-0xf083 flags 0x40101] (d=0, p=0)
[    0.138334] pci 0000:00:1f.2: BAR 4: reserving [io  0xf060-0xf07f flags 0x40101] (d=0, p=0)
[    0.138339] pci 0000:00:1f.2: BAR 5: reserving [mem 0xf6806000-0xf68067ff flags 0x40200] (d=0, p=0)
[    0.138347] pci 0000:00:1f.3: BAR 0: reserving [mem 0xf6805000-0xf68050ff flags 0x140204] (d=0, p=0)
[    0.138351] pci 0000:00:1f.3: BAR 4: reserving [io  0xf040-0xf05f flags 0x40101] (d=0, p=0)
[    0.138374] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.138377] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.138380] e820: reserve RAM buffer [mem 0x74fd9000-0x77ffffff]
[    0.138384] e820: reserve RAM buffer [mem 0x7569d000-0x77ffffff]
[    0.138387] e820: reserve RAM buffer [mem 0x76000000-0x77ffffff]
[    0.138390] e820: reserve RAM buffer [mem 0x100600000-0x103ffffff]
[    0.138700] cfg80211: Calling CRDA to update world regulatory domain
[    0.138808] NetLabel: Initializing
[    0.138811] NetLabel:  domain hash size = 128
[    0.138813] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.138838] NetLabel:  unlabeled traffic allowed by default
[    0.138977] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.138987] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.141031] Switched to clocksource hpet
[    0.145563] pnp: PnP ACPI init
[    0.145575] ACPI: bus type PNP registered
[    0.145735] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.145742] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.145763] pnp 00:01: [dma 4]
[    0.145821] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.145889] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.146113] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.146209] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.146213] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.146217] system 00:04: [io  0xffff] has been reserved
[    0.146220] system 00:04: [io  0xffff] has been reserved
[    0.146224] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.146227] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.146230] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.146234] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.146238] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.146317] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.146426] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.146431] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.146680] system 00:07: [io  0x0a00-0x0a1f] has been reserved
[    0.146685] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.146688] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.146692] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.146836] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.146841] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.146919] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.147374] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.147379] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.147382] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.147386] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.147390] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.147393] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.147397] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.147400] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.147403] system 00:0a: [mem 0xff000000-0xffffffff] has been reserved
[    0.147407] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.147411] system 00:0a: [mem 0x7ea00000-0x7ea00fff] has been reserved
[    0.147415] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.147723] system 00:0b: [mem 0x20000000-0x201fffff] has been reserved
[    0.147728] system 00:0b: [mem 0x40004000-0x40004fff] has been reserved
[    0.147732] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.147768] pnp: PnP ACPI: found 12 devices
[    0.147771] ACPI: bus type PNP unregistered
[    0.157917] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.157942] pci 0000:00:1c.4: PCI bridge to [bus 02-3a]
[    0.157947] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
[    0.157956] pci 0000:00:1c.4:   bridge window [mem 0xe0000000-0xf60fffff]
[    0.157963] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xd1ffffff 64bit pref]
[    0.157975] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.157978] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.157982] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.157985] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.157988] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.157991] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.157994] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.157997] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.158001] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.158004] pci_bus 0000:00: resource 13 [mem 0x7ea00000-0xfeafffff]
[    0.158008] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.158011] pci_bus 0000:02: resource 1 [mem 0xe0000000-0xf60fffff]
[    0.158014] pci_bus 0000:02: resource 2 [mem 0xb0000000-0xd1ffffff 64bit pref]
[    0.158061] NET: Registered protocol family 2
[    0.158208] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.158263] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.158305] TCP: Hash tables configured (established 16384 bind 16384)
[    0.158326] TCP: reno registered
[    0.158334] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.158346] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.158405] NET: Registered protocol family 1
[    0.158493] RPC: Registered named UNIX socket transport module.
[    0.158496] RPC: Registered udp transport module.
[    0.158499] RPC: Registered tcp transport module.
[    0.158501] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.158514] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xd0
[    0.158517] pci 0000:00:02.0: Boot video device
[    0.158530] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x6f0
[    0.158794] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x6f0
[    0.159011] PCI: CLS 64 bytes, default 64
[    0.159084] Unpacking initramfs...
[    1.127055] Freeing initrd memory: 4216K (ffff880075bd8000 - ffff880075ff6000)
[    1.127065] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.127069] software IO TLB [mem 0x6ee00000-0x72e00000] (64MB) mapped at [ffff88006ee00000-ffff880072dfffff]
[    1.128063] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
[    1.128072] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
[    1.128082] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
[    1.128094] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
[    1.128171] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.128176] Scanning for low memory corruption every 60 seconds
[    1.128834] audit: initializing netlink socket (disabled)
[    1.128853] type=2000 audit(1385400418.121:1): initialized
[    1.162177] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.166132] VFS: Disk quotas dquot_6.5.2
[    1.166217] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.167493] NFS: Registering the id_resolver key type
[    1.167503] Key type id_resolver registered
[    1.167506] Key type id_legacy registered
[    1.167599] msgmni has been set to 3541
[    1.167696] SELinux:  Registering netfilter hooks
[    1.168244] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.168249] io scheduler noop registered
[    1.168251] io scheduler deadline registered
[    1.168319] io scheduler cfq registered (default)
[    1.168873] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.169014] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.169307] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.169315] ACPI: Power Button [PWRB]
[    1.169393] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.169398] ACPI: Power Button [PWRF]
[    1.169550] ACPI: Fan [FAN0] (off)
[    1.169629] ACPI: Fan [FAN1] (off)
[    1.169714] ACPI: Fan [FAN2] (off)
[    1.169790] ACPI: Fan [FAN3] (off)
[    1.169864] ACPI: Fan [FAN4] (off)
[    1.175207] Monitor-Mwait will be used to enter C-1 state
[    1.175214] Monitor-Mwait will be used to enter C-2 state
[    1.175220] ACPI: acpi_idle registered with cpuidle
[    1.182397] thermal LNXTHERM:00: registered as thermal_zone0
[    1.182402] ACPI: Thermal Zone [TZ00] (28 C)
[    1.182824] thermal LNXTHERM:01: registered as thermal_zone1
[    1.182828] ACPI: Thermal Zone [TZ01] (30 C)
[    1.183047] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.184019] Non-volatile memory driver v1.3
[    1.184023] Linux agpgart interface v0.103
[    1.184228] [drm] Initialized drm 1.1.0 20060810
[    1.185745] [drm] Memory usable by graphics device = 2048M
[    1.232896] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.232908] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.232911] [drm] Driver supports precise vblank timestamp query.
[    1.233054] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.310810] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    1.319172] i915 0000:00:02.0: No connectors reported connected with modes
[    1.319181] [drm] Cannot find any crtc or sizes - going 1024x768
[    1.320518] fbcon: inteldrmfb (fb0) is primary device
[    1.346832] Console: switching to colour frame buffer device 128x48
[    1.349241] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.349275] i915 0000:00:02.0: registered panic notifier
[    1.354906] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.355244] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    1.355432] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.357143] loop: module loaded
[    1.357466] ahci 0000:00:1f.2: version 3.0
[    1.357656] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.357703] ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x3f
[    1.357799] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    1.357862] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    1.357908] ahci 0000:00:1f.2: enabling bus mastering
[    1.359261] scsi0 : ahci
[    1.359430] scsi1 : ahci
[    1.359579] scsi2 : ahci
[    1.359729] scsi3 : ahci
[    1.359899] scsi4 : ahci
[    1.361028] scsi5 : ahci
[    1.362125] ata1: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806100 irq 41
[    1.363173] ata2: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806180 irq 41
[    1.364218] ata3: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806200 irq 41
[    1.365247] ata4: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806280 irq 41
[    1.366267] ata5: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806300 irq 41
[    1.367266] ata6: SATA max UDMA/133 abar m2048@0xf6806000 port 0xf6806380 irq 41
[    1.368736] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.369732] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.370807] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.371809] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.372899] sky2: driver version 1.30
[    1.374472] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.375490] ehci-pci: EHCI PCI platform driver
[    1.376656] ehci-pci 0000:00:1a.0: enabling bus mastering
[    1.377677] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.378764] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.379788] ehci-pci 0000:00:1a.0: debug port 2
[    1.384681] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.385682] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf6808000
[    1.391869] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.392841] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.393791] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.394734] usb usb1: Product: EHCI Host Controller
[    1.395669] usb usb1: Manufacturer: Linux 3.13.0-rc1+ ehci_hcd
[    1.396595] usb usb1: SerialNumber: 0000:00:1a.0
[    1.397702] hub 1-0:1.0: USB hub found
[    1.398634] hub 1-0:1.0: 2 ports detected
[    1.399791] ehci-pci 0000:00:1d.0: enabling bus mastering
[    1.400694] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.401694] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.402584] ehci-pci 0000:00:1d.0: debug port 2
[    1.407369] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.408269] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf6807000
[    1.414887] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.415783] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.416664] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.417549] usb usb2: Product: EHCI Host Controller
[    1.418426] usb usb2: Manufacturer: Linux 3.13.0-rc1+ ehci_hcd
[    1.419317] usb usb2: SerialNumber: 0000:00:1d.0
[    1.420469] hub 2-0:1.0: USB hub found
[    1.421398] hub 2-0:1.0: 2 ports detected
[    1.422521] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.423483] ohci-pci: OHCI PCI platform driver
[    1.424504] uhci_hcd: USB Universal Host Controller Interface driver
[    1.425733] usbcore: registered new interface driver usblp
[    1.426789] usbcore: registered new interface driver usb-storage
[    1.427890] usbcore: registered new interface driver usbserial
[    1.428946] usbcore: registered new interface driver pl2303
[    1.430017] usbserial: USB Serial support registered for pl2303
[    1.431281] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.130354] tsc: Refined TSC clocksource calibration: 1797.677 MHz
[    2.375510] ata4: failed to resume link (SControl 0)
[    2.376831] ata4: SATA link down (SStatus 0 SControl 0)
[    2.378135] ata1: failed to resume link (SControl 0)
[    2.379447] ata1: SATA link down (SStatus 0 SControl 0)
[    2.380748] ata5: failed to resume link (SControl 0)
[    2.382057] ata5: SATA link down (SStatus 0 SControl 0)
[    2.383366] ata2: failed to resume link (SControl 0)
[    2.384697] ata2: SATA link down (SStatus 0 SControl 0)
[    2.386007] ata3: failed to resume link (SControl 0)
[    2.387308] ata3: SATA link down (SStatus 0 SControl 0)
[    2.531573] i8042: No controller found
[    2.532683] mousedev: PS/2 mouse device common for all mice
[    2.534152] rtc_cmos 00:05: RTC can wake from S4
[    2.535282] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.536269] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.537454] ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130927/utaddress-251)
[    2.539481] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.540968] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    2.542162] hidraw: raw HID events driver (C) Jiri Kosina
[    2.544258] usbcore: registered new interface driver usbhid
[    2.545370] usbhid: USB HID core driver
[    2.547236] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    2.548392] snd_hda_intel 0000:00:1b.0: enabling bus mastering
[    2.557061] Netfilter messages via NETLINK v0.30.
[    2.558188] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.559426] ctnetlink v0.93: registering with nfnetlink.
[    2.560649] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.561775] TCP: cubic registered
[    2.562871] Initializing XFRM netlink socket
[    2.564272] NET: Registered protocol family 10
[    2.565541] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.566701] sit: IPv6 over IPv4 tunneling driver
[    2.568055] NET: Registered protocol family 17
[    2.569188] Key type dns_resolver registered
[    2.570911] registered taskstats version 1
[    2.572300]   Magic number: 5:89:442
[    2.573443] console [netcon0] enabled
[    2.574530] netconsole: network logging started
[    2.575682] rtc_cmos 00:05: setting system clock to 2013-11-25 17:26:59 UTC (1385400419)
[    2.577577] PM: Hibernation image not present or could not be loaded.
[    2.578724] ALSA device list:
[    2.579837]   #0: HDA Intel PCH at 0xf6800000 irq 42
[    2.711164] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.733804] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.790813] ata6: failed to resume link (SControl 0)
[    2.791960] ata6: SATA link down (SStatus 0 SControl 0)
[    2.794100] Freeing unused kernel memory: 1064K (ffffffff81ee3000 - ffffffff81fed000)
[    2.795259] Write protecting the kernel read-only data: 14336k
[    2.801642] Freeing unused kernel memory: 1904K (ffff880001824000 - ffff880001a00000)
[    2.806242] Freeing unused kernel memory: 1276K (ffff880001cc1000 - ffff880001e00000)
[    2.824669] udevd[1067]: starting version 182
[    2.842541] udevadm (1068) used greatest stack depth: 5808 bytes left
[    2.849357] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.850833] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.852444] hub 1-1:1.0: USB hub found
[    2.852930] random: dd urandom read with 10 bits of entropy available
[    2.855527] hub 1-1:1.0: 6 ports detected
[    2.874773] ip (1091) used greatest stack depth: 5152 bytes left
[    2.958919] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.074455] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    3.075627] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.077076] hub 2-1:1.0: USB hub found
[    3.078454] hub 2-1:1.0: 8 ports detected
[    3.132145] Switched to clocksource tsc
[    3.355259] usb 2-1.2: new high-speed USB device number 3 using ehci-pci
[    3.443093] usb 2-1.2: New USB device found, idVendor=05e3, idProduct=0608
[    3.444283] usb 2-1.2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.445501] usb 2-1.2: Product: USB2.0 Hub
[    3.447114] hub 2-1.2:1.0: USB hub found
[    3.448721] hub 2-1.2:1.0: 4 ports detected
[    3.716770] usb 2-1.2.1: new full-speed USB device number 4 using ehci-pci
[    3.793943] usb 2-1.2.1: New USB device found, idVendor=067b, idProduct=2303
[    3.795156] usb 2-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.796379] usb 2-1.2.1: Product: USB-Serial Controller D
[    3.797560] usb 2-1.2.1: Manufacturer: Prolific Technology Inc. 
[    3.799060] pl2303 2-1.2.1:1.0: pl2303 converter detected
[    3.802641] usb 2-1.2.1: pl2303 converter now attached to ttyUSB0
[    3.866864] usb 2-1.2.2: new full-speed USB device number 5 using ehci-pci
[    4.005068] usb 2-1.2.2: new high-speed USB device number 6 using ehci-pci
[    4.110246] usb 2-1.2.2: New USB device found, idVendor=0b95, idProduct=7720
[    4.111414] usb 2-1.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.112567] usb 2-1.2.2: Product: AX88772 
[    4.113692] usb 2-1.2.2: SerialNumber: 006BC1
[    4.190199] usb 2-1.2.3: new high-speed USB device number 7 using ehci-pci
[    4.283487] usb 2-1.2.3: New USB device found, idVendor=090c, idProduct=6200
[    4.284622] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.285764] usb 2-1.2.3: Product: Generic USB2.0 card 
[    4.286890] usb 2-1.2.3: Manufacturer: Silicon Motion, Inc.
[    4.288003] usb 2-1.2.3: SerialNumber: 12345678901234567890
[    4.289374] usb-storage 2-1.2.3:1.0: USB Mass Storage device detected
[    4.290990] scsi6 : usb-storage 2-1.2.3:1.0
[    5.413622] scsi 6:0:0:0: Direct-Access     Generic  USB  SD Reader   1.00 PQ: 0 ANSI: 0 CCS
[    5.414859] sd 6:0:0:0: Attached scsi generic sg0 type 0
[    5.416606] sd 6:0:0:0: [sda] 7626752 512-byte logical blocks: (3.90 GB/3.63 GiB)
[    5.418315] sd 6:0:0:0: [sda] Write Protect is off
[    5.419401] sd 6:0:0:0: [sda] Mode Sense: 4b 00 00 08
[    5.421236] sd 6:0:0:0: [sda] No Caching mode page found
[    5.422306] sd 6:0:0:0: [sda] Assuming drive cache: write through
[    5.426442] sd 6:0:0:0: [sda] No Caching mode page found
[    5.427487] sd 6:0:0:0: [sda] Assuming drive cache: write through
[    5.429875]  sda: sda1
[    5.435197] sd 6:0:0:0: [sda] No Caching mode page found
[    5.436247] sd 6:0:0:0: [sda] Assuming drive cache: write through
[    5.437297] sd 6:0:0:0: [sda] Attached SCSI removable disk
[    8.582397] udevd (1069) used greatest stack depth: 5056 bytes left
[   53.861699] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[   53.862772] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[   53.863909] pci 0000:02:00.0: [8086:1548] type 01 class 0x060400
[   53.865107] pci 0000:02:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.866334] pci 0000:02:00.0: supports D1 D2
[   53.867363] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.868431] pci 0000:02:00.0: PME# disabled
[   53.869552] pci 0000:02:00.0: System wakeup disabled by ACPI
[   53.872530] pci 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 0
[   53.873767] pci_bus 0000:03: scanning bus
[   53.874941] pci 0000:03:00.0: [8086:1548] type 01 class 0x060400
[   53.876168] pci 0000:03:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.877404] pci 0000:03:00.0: supports D1 D2
[   53.878451] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.879526] pci 0000:03:00.0: PME# disabled
[   53.880744] pci 0000:03:03.0: [8086:1548] type 01 class 0x060400
[   53.882003] pci 0000:03:03.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.883237] pci 0000:03:03.0: supports D1 D2
[   53.884284] pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.885361] pci 0000:03:03.0: PME# disabled
[   53.886582] pci 0000:03:04.0: [8086:1548] type 01 class 0x060400
[   53.887827] pci 0000:03:04.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.889059] pci 0000:03:04.0: supports D1 D2
[   53.890105] pci 0000:03:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.891172] pci 0000:03:04.0: PME# disabled
[   53.892383] pci 0000:03:05.0: [8086:1548] type 01 class 0x060400
[   53.893615] pci 0000:03:05.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.894843] pci 0000:03:05.0: supports D1 D2
[   53.895882] pci 0000:03:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.896935] pci 0000:03:05.0: PME# disabled
[   53.898104] pci 0000:03:06.0: [8086:1548] type 01 class 0x060400
[   53.899291] pci 0000:03:06.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   53.900486] pci 0000:03:06.0: supports D1 D2
[   53.901496] pci 0000:03:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[   53.902544] pci 0000:03:06.0: PME# disabled
[   53.903776] pci_bus 0000:03: fixups for bus
[   53.904818] pci 0000:02:00.0: PCI bridge to [bus 03-3a]
[   53.905881] pci 0000:02:00.0:   bridge window [mem 0xe0000000-0xf60fffff]
[   53.906932] pci 0000:02:00.0:   bridge window [mem 0xb0000000-0xd1ffffff 64bit pref]
[   53.907970] pci 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 0
[   53.909174] pci_bus 0000:04: scanning bus
[   53.910268] pci_bus 0000:04: fixups for bus
[   53.911283] pci 0000:03:00.0: PCI bridge to [bus 04]
[   53.912326] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf60fffff]
[   53.913366] pci_bus 0000:04: bus scan returning with max=04
[   53.914386] pci 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 0
[   53.915580] pci_bus 0000:05: scanning bus
[   53.916649] pci_bus 0000:05: fixups for bus
[   53.917648] pci 0000:03:03.0: PCI bridge to [bus 05-2f]
[   53.918676] pci 0000:03:03.0:   bridge window [mem 0xe0000000-0xedffffff]
[   53.919712] pci 0000:03:03.0:   bridge window [mem 0xb0000000-0xc9ffffff 64bit pref]
[   53.920721] pci_bus 0000:05: bus scan returning with max=05
[   53.921738] pci 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 0
[   53.922921] pci_bus 0000:30: scanning bus
[   53.923986] pci_bus 0000:30: fixups for bus
[   53.924984] pci 0000:03:04.0: PCI bridge to [bus 30-38]
[   53.926010] pci 0000:03:04.0:   bridge window [mem 0xee000000-0xf5ffffff]
[   53.927044] pci 0000:03:04.0:   bridge window [mem 0xca000000-0xd1ffffff 64bit pref]
[   53.928048] pci_bus 0000:30: bus scan returning with max=30
[   53.929071] pci 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 0
[   53.930256] pci_bus 0000:39: scanning bus
[   53.931632] pci_bus 0000:39: fixups for bus
[   53.932878] pci 0000:03:05.0: PCI bridge to [bus 39]
[   53.933930] pci_bus 0000:39: bus scan returning with max=39
[   53.934951] pci 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 0
[   53.936142] pci_bus 0000:3a: scanning bus
[   53.937216] pci_bus 0000:3a: fixups for bus
[   53.938218] pci 0000:03:06.0: PCI bridge to [bus 3a]
[   53.939265] pci_bus 0000:3a: bus scan returning with max=3a
[   53.940292] pci 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 1
[   53.941337] pci 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 1
[   53.942364] pci 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 1
[   53.943382] pci 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 1
[   53.944391] pci 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 1
[   53.945380] pci_bus 0000:03: bus scan returning with max=3a
[   53.946372] pci 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 1
[   53.947374] pci_bus 0000:03: Allocating resources
[   53.948445] pci 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[   53.949467] pci 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   53.950551] pci 0000:03:03.0: bridge window [io  0x1000-0x0fff] to [bus 05-2f] add_size 1000
[   53.951628] pci 0000:03:04.0: bridge window [io  0x1000-0x0fff] to [bus 30-38] add_size 1000
[   53.952708] pci 0000:03:05.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[   53.953738] pci 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000
[   53.954777] pci 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 39] add_size 200000
[   53.955855] pci 0000:03:06.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[   53.956907] pci 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[   53.957976] pci 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[   53.959069] pci 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.960130] pci 0000:03:03.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.961164] pci 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.962194] pci 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.963210] pci 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.964209] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus 03-3a] add_size 5000
[   53.965231] pci 0000:02:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 5000
[   53.966252] pci 0000:02:00.0: BAR 7: can't assign io (size 0x5000)
[   53.967263] pci 0000:02:00.0: BAR 7: can't assign io (size 0x5000)
[   53.968255] pci 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   53.969288] pci 0000:03:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   53.970322] pci 0000:03:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   53.971362] pci 0000:03:06.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   53.972408] pci 0000:03:06.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   53.973450] pci 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.974493] pci 0000:03:03.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.975516] pci 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.976540] pci 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.977545] pci 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   53.978531] pci 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.979521] pci 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   53.980494] pci 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.981469] pci 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   53.982442] pci 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.983405] pci 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   53.984357] pci 0000:03:03.0: BAR 7: can't assign io (size 0x1000)
[   53.985307] pci 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   53.986251] pci 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   53.987190] pci 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   53.988128] pci 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   53.989044] pci 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.989948] pci 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   53.990838] pci 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   53.991707] pci 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.992555] pci 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   53.993375] pci 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   53.994196] pci 0000:03:03.0: BAR 7: can't assign io (size 0x1000)
[   53.995012] pci 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   53.995813] pci 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   53.996603] pci 0000:03:00.0: PCI bridge to [bus 04]
[   53.997392] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf60fffff]
[   53.998192] pci 0000:03:03.0: PCI bridge to [bus 05-2f]
[   53.998977] pci 0000:03:03.0:   bridge window [mem 0xe0000000-0xedffffff]
[   53.999755] pci 0000:03:03.0:   bridge window [mem 0xb0000000-0xc9ffffff 64bit pref]
[   54.000554] pci 0000:03:04.0: PCI bridge to [bus 30-38]
[   54.001353] pci 0000:03:04.0:   bridge window [mem 0xee000000-0xf5ffffff]
[   54.002175] pci 0000:03:04.0:   bridge window [mem 0xca000000-0xd1ffffff 64bit pref]
[   54.003022] pci 0000:03:05.0: PCI bridge to [bus 39]
[   54.003866] pci 0000:03:06.0: PCI bridge to [bus 3a]
[   54.004687] pci 0000:02:00.0: PCI bridge to [bus 03-3a]
[   54.005457] pci 0000:02:00.0:   bridge window [mem 0xe0000000-0xf60fffff]
[   54.006254] pci 0000:02:00.0:   bridge window [mem 0xb0000000-0xd1ffffff 64bit pref]
[   54.007613] pcieport 0000:00:1c.4: enabling bus mastering
[   54.008516] pcieport 0000:02:00.0: irq 43 for MSI/MSI-X
[   54.009717] pcieport 0000:03:00.0: irq 44 for MSI/MSI-X
[   54.010855] pcieport 0000:03:03.0: irq 45 for MSI/MSI-X
[   54.012000] pcieport 0000:03:04.0: irq 46 for MSI/MSI-X
[   54.013114] pcieport 0000:03:05.0: irq 47 for MSI/MSI-X
[   54.014221] pcieport 0000:03:06.0: irq 48 for MSI/MSI-X
[   57.433748] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[   57.434473] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[   57.435267] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 0
[   57.436020] pci_bus 0000:03: scanning bus
[   57.436883] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 0
[   57.437658] pci_bus 0000:04: scanning bus
[   57.438433] pci_bus 0000:04: bus scan returning with max=04
[   57.439216] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 0
[   57.440019] pci_bus 0000:05: scanning bus
[   57.440876] pci 0000:05:00.0: [8086:1513] type 01 class 0x060400
[   57.441845] pci 0000:05:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   57.442840] pci 0000:05:00.0: supports D1 D2
[   57.443688] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   57.444577] pci 0000:05:00.0: PME# disabled
[   57.445609] pci 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 0
[   57.446701] pci_bus 0000:06: scanning bus
[   57.447717] pci 0000:06:03.0: [8086:1513] type 01 class 0x060400
[   57.448786] pci 0000:06:03.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   57.449868] pci 0000:06:03.0: supports D1 D2
[   57.450797] pci 0000:06:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[   57.451775] pci 0000:06:03.0: PME# disabled
[   57.452880] pci 0000:06:04.0: [8086:1513] type 01 class 0x060400
[   57.454037] pci 0000:06:04.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   57.455160] pci 0000:06:04.0: supports D1 D2
[   57.456124] pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[   57.457120] pci 0000:06:04.0: PME# disabled
[   57.458225] pci 0000:06:05.0: [8086:1513] type 01 class 0x060400
[   57.459372] pci 0000:06:05.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   57.460501] pci 0000:06:05.0: supports D1 D2
[   57.461463] pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[   57.462466] pci 0000:06:05.0: PME# disabled
[   57.463626] pci_bus 0000:06: fixups for bus
[   57.465217] pci 0000:05:00.0: PCI bridge to [bus 06-2f]
[   57.466617] pci 0000:05:00.0:   bridge window [mem 0xe0000000-0xedffffff]
[   57.468020] pci 0000:05:00.0:   bridge window [mem 0xb0000000-0xc9ffffff 64bit pref]
[   57.469415] pci 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 0
[   57.470938] pci_bus 0000:07: scanning bus
[   57.472040] pci 0000:07:00.0: [1b4b:9182] type 00 class 0x010601
[   57.473116] pci 0000:07:00.0: reg 0x10: [io  0x8000-0x8007]
[   57.474185] pci 0000:07:00.0: reg 0x14: [io  0x8040-0x8043]
[   57.475258] pci 0000:07:00.0: reg 0x18: [io  0x8100-0x8107]
[   57.476334] pci 0000:07:00.0: reg 0x1c: [io  0x8140-0x8143]
[   57.477415] pci 0000:07:00.0: reg 0x20: [io  0x800000-0x80000f]
[   57.478476] pci 0000:07:00.0: reg 0x24: [mem 0xe0100000-0xe01001ff]
[   57.479537] pci 0000:07:00.0: reg 0x30: [mem 0xe0120000-0xe013ffff pref]
[   57.480713] pci 0000:07:00.0: PME# supported from D3hot
[   57.481715] pci 0000:07:00.0: PME# disabled
[   57.482867] pci_bus 0000:07: fixups for bus
[   57.483839] pci 0000:06:03.0: PCI bridge to [bus 07]
[   57.484813] pci 0000:06:03.0:   bridge window [io  0xf000-0xe0000fff]
[   57.485779] pci 0000:06:03.0:   bridge window [mem 0xe0000000-0xe3ffffff]
[   57.486737] pci 0000:06:03.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
[   57.487679] pci_bus 0000:07: bus scan returning with max=07
[   57.488623] pci 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 0
[   57.489683] pci_bus 0000:08: scanning bus
[   57.490680] pci_bus 0000:08: fixups for bus
[   57.491614] pci 0000:06:04.0: PCI bridge to [bus 08-2e]
[   57.492572] pci 0000:06:04.0:   bridge window [mem 0xe4000000-0xedffffff]
[   57.493520] pci 0000:06:04.0:   bridge window [mem 0xc0000000-0xc9ffffff 64bit pref]
[   57.494448] pci_bus 0000:08: bus scan returning with max=08
[   57.495381] pci 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 0
[   57.496429] pci_bus 0000:2f: scanning bus
[   57.497414] pci_bus 0000:2f: fixups for bus
[   57.498334] pci 0000:06:05.0: PCI bridge to [bus 2f]
[   57.499292] pci_bus 0000:2f: bus scan returning with max=2f
[   57.500226] pci 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 1
[   57.501180] pci 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 1
[   57.502117] pci 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 1
[   57.503042] pci_bus 0000:06: bus scan returning with max=2f
[   57.503964] pci 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 1
[   57.504900] pci_bus 0000:05: bus scan returning with max=2f
[   57.505830] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 0
[   57.506775] pci_bus 0000:30: scanning bus
[   57.507714] pci_bus 0000:30: bus scan returning with max=30
[   57.508667] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 0
[   57.509636] pci_bus 0000:39: scanning bus
[   57.510598] pci_bus 0000:39: bus scan returning with max=39
[   57.511573] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 0
[   57.512552] pci_bus 0000:3a: scanning bus
[   57.513520] pci_bus 0000:3a: bus scan returning with max=3a
[   57.514493] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 1
[   57.515487] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 1
[   57.516481] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 1
[   57.517475] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 1
[   57.518470] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 1
[   57.519456] pci_bus 0000:03: bus scan returning with max=3a
[   57.520444] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 1
[   57.521455] pci_bus 0000:03: Allocating resources
[   57.522460] pci 0000:06:03.0: no compatible bridge window for [io  0xf000-0xe0000fff]
[   57.523519] pci 0000:07:00.0: BAR 5: reserving [mem 0xe0100000-0xe01001ff flags 0x40200] (d=0, p=0)
[   57.524614] pci 0000:07:00.0: BAR 0: reserving [io  0x8000-0x8007 flags 0x40101] (d=1, p=1)
[   57.525684] pci 0000:07:00.0: no compatible bridge window for [io  0x8000-0x8007]
[   57.526756] pci 0000:07:00.0: BAR 1: reserving [io  0x8040-0x8043 flags 0x40101] (d=1, p=1)
[   57.527847] pci 0000:07:00.0: no compatible bridge window for [io  0x8040-0x8043]
[   57.528949] pci 0000:07:00.0: BAR 2: reserving [io  0x8100-0x8107 flags 0x40101] (d=1, p=1)
[   57.530052] pci 0000:07:00.0: no compatible bridge window for [io  0x8100-0x8107]
[   57.531151] pci 0000:07:00.0: BAR 3: reserving [io  0x8140-0x8143 flags 0x40101] (d=1, p=1)
[   57.532252] pci 0000:07:00.0: no compatible bridge window for [io  0x8140-0x8143]
[   57.533373] pci 0000:07:00.0: BAR 4: reserving [io  0x800000-0x80000f flags 0x40101] (d=1, p=1)
[   57.534506] pci 0000:07:00.0: no compatible bridge window for [io  0x800000-0x80000f]
[   57.535671] pcieport 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[   57.536838] pcieport 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   57.538057] pci 0000:06:04.0: bridge window [io  0x1000-0x0fff] to [bus 08-2e] add_size 1000
[   57.539261] pci 0000:06:05.0: bridge window [io  0x1000-0x0fff] to [bus 2f] add_size 1000
[   57.540429] pci 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 2f] add_size 200000
[   57.541626] pci 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 2f] add_size 200000
[   57.542840] pci 0000:06:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.544043] pci 0000:06:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.545222] pci 0000:05:00.0: bridge window [io  0x1000-0x1fff] to [bus 06-2f] add_size 2000
[   57.546439] pci 0000:05:00.0: res[7]=[io  0x1000-0x1fff] get_res_add_size add_size 2000
[   57.547661] pcieport 0000:03:03.0: bridge window [io  0x1000-0x1fff] to [bus 05-2f] add_size 2000
[   57.548908] pcieport 0000:03:04.0: bridge window [io  0x1000-0x0fff] to [bus 30-38] add_size 1000
[   57.550141] pcieport 0000:03:05.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[   57.551341] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000
[   57.552554] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 39] add_size 200000
[   57.553767] pcieport 0000:03:06.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[   57.554974] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[   57.556190] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[   57.557403] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.558617] pcieport 0000:03:03.0: res[7]=[io  0x1000-0x1fff] get_res_add_size add_size 2000
[   57.559809] pcieport 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.560981] pcieport 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.562135] pcieport 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.563267] pcieport 0000:02:00.0: bridge window [io  0x1000-0x1fff] to [bus 03-3a] add_size 6000
[   57.564420] pcieport 0000:02:00.0: res[7]=[io  0x1000-0x1fff] get_res_add_size add_size 6000
[   57.565593] pcieport 0000:02:00.0: BAR 7: can't assign io (size 0x7000)
[   57.566773] pcieport 0000:02:00.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.567960] pcieport 0000:02:00.0: BAR 7: can't assign io (size 0x1000)
[   57.569130] pcieport 0000:02:00.0: failed to add 6000 res[7]=[io  0x2000-0x2fff]
[   57.570301] pcieport 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.571487] pcieport 0000:03:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.572659] pcieport 0000:03:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.573822] pcieport 0000:03:06.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.574981] pcieport 0000:03:06.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.576137] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.577293] pcieport 0000:03:03.0: res[7]=[io  0x1000-0x1fff] get_res_add_size add_size 2000
[   57.578429] pcieport 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.579544] pcieport 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.580638] pcieport 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.581704] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.582766] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.583815] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.584846] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   57.585854] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.586845] pcieport 0000:03:00.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.587813] pcieport 0000:03:03.0: BAR 7: can't assign io (size 0x3000)
[   57.588785] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   57.589729] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   57.590660] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   57.591562] pcieport 0000:03:03.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.592474] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   57.593378] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.594267] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   57.595132] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.596002] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.596868] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   57.597718] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   57.598553] pcieport 0000:03:03.0: BAR 7: can't assign io (size 0x1000)
[   57.599363] pcieport 0000:03:03.0: failed to add 2000 res[7]=[io  0x2000-0x2fff]
[   57.600165] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.600973] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   57.601754] pci 0000:05:00.0: res[7]=[io  0x1000-0x1fff] get_res_add_size add_size 2000
[   57.602570] pci 0000:05:00.0: BAR 7: can't assign io (size 0x3000)
[   57.603398] pci 0000:05:00.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.604234] pci 0000:05:00.0: BAR 7: can't assign io (size 0x1000)
[   57.605084] pci 0000:05:00.0: failed to add 2000 res[7]=[io  0x2000-0x2fff]
[   57.605923] pci 0000:06:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.606779] pci 0000:06:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.607636] pci 0000:06:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.608509] pci 0000:06:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.609369] pci 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.610229] pci 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.611069] pci 0000:06:03.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.611895] pci 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   57.612714] pci 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   57.613518] pci 0000:06:03.0: BAR 7: assigned [io  0x2000-0x2fff]
[   57.614314] pci 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.615098] pci 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.615885] pci 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   57.616677] pci 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   57.617473] pci 0000:07:00.0: BAR 4: assigned [io  0x2000-0x200f]
[   57.618292] pci 0000:07:00.0: BAR 4: set to [io  0x2000-0x200f] (PCI address [0x2000-0x200f])
[   57.619113] pci 0000:07:00.0: BAR 0: assigned [io  0x2010-0x2017]
[   57.619939] pci 0000:07:00.0: BAR 0: set to [io  0x2010-0x2017] (PCI address [0x2010-0x2017])
[   57.620777] pci 0000:07:00.0: BAR 2: assigned [io  0x2018-0x201f]
[   57.621626] pci 0000:07:00.0: BAR 2: set to [io  0x2018-0x201f] (PCI address [0x2018-0x201f])
[   57.622490] pci 0000:07:00.0: BAR 1: assigned [io  0x2020-0x2023]
[   57.623352] pci 0000:07:00.0: BAR 1: set to [io  0x2020-0x2023] (PCI address [0x2020-0x2023])
[   57.624225] pci 0000:07:00.0: BAR 3: assigned [io  0x2024-0x2027]
[   57.625118] pci 0000:07:00.0: BAR 3: set to [io  0x2024-0x2027] (PCI address [0x2024-0x2027])
[   57.626033] pci 0000:06:03.0: PCI bridge to [bus 07]
[   57.626961] pci 0000:06:03.0:   bridge window [io  0x2000-0x2fff]
[   57.627893] pci 0000:06:03.0:   bridge window [mem 0xe0000000-0xe3ffffff]
[   57.628826] pci 0000:06:03.0:   bridge window [mem 0xb0000000-0xbfffffff 64bit pref]
[   57.629769] pci 0000:06:04.0: PCI bridge to [bus 08-2e]
[   57.630710] pci 0000:06:04.0:   bridge window [mem 0xe4000000-0xedffffff]
[   57.631660] pci 0000:06:04.0:   bridge window [mem 0xc0000000-0xc9ffffff 64bit pref]
[   57.632619] pci 0000:06:05.0: PCI bridge to [bus 2f]
[   57.633599] pci 0000:05:00.0: PCI bridge to [bus 06-2f]
[   57.634556] pci 0000:05:00.0:   bridge window [io  0x2000-0x2fff]
[   57.635539] pci 0000:05:00.0:   bridge window [mem 0xe0000000-0xedffffff]
[   57.636515] pci 0000:05:00.0:   bridge window [mem 0xb0000000-0xc9ffffff 64bit pref]
[   57.638252] pcieport 0000:05:00.0: enabling device (0106 -> 0107)
[   57.639347] pcieport 0000:05:00.0: irq 49 for MSI/MSI-X
[   57.640506] pcieport 0000:06:03.0: enabling device (0106 -> 0107)
[   57.641611] pcieport 0000:06:03.0: irq 50 for MSI/MSI-X
[   57.642877] pcieport 0000:06:04.0: irq 51 for MSI/MSI-X
[   57.644169] pcieport 0000:06:05.0: irq 52 for MSI/MSI-X
[   57.645342] ahci 0000:07:00.0: enabling device (0106 -> 0107)
[   57.646402] ahci 0000:07:00.0: irq 53 for MSI/MSI-X
[   57.647439] ahci 0000:07:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[   57.648355] ahci 0000:07:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[   57.649690] scsi7 : ahci
[   57.650977] scsi8 : ahci
[   57.652015] ata7: SATA max UDMA/133 abar m512@0xe0100000 port 0xe0100100 irq 53
[   57.653029] ata8: SATA max UDMA/133 abar m512@0xe0100000 port 0xe0100180 irq 53
[   57.664463] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[   57.665430] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[   57.666453] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 0
[   57.667441] pci_bus 0000:03: scanning bus
[   57.668479] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 0
[   57.669500] pci_bus 0000:04: scanning bus
[   57.670526] pci_bus 0000:04: bus scan returning with max=04
[   57.671559] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 0
[   57.672602] pci_bus 0000:05: scanning bus
[   57.673629] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 0
[   57.674680] pci_bus 0000:06: scanning bus
[   57.675812] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 0
[   57.676872] pci_bus 0000:07: scanning bus
[   57.677911] pci_bus 0000:07: bus scan returning with max=07
[   57.678956] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 0
[   57.680014] pci_bus 0000:08: scanning bus
[   57.681055] pci_bus 0000:08: bus scan returning with max=08
[   57.682090] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 0
[   57.683148] pci_bus 0000:2f: scanning bus
[   57.684201] pci_bus 0000:2f: bus scan returning with max=2f
[   57.685267] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 1
[   57.686349] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 1
[   57.687419] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 1
[   57.688481] pci_bus 0000:06: bus scan returning with max=2f
[   57.689538] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 1
[   57.690622] pci_bus 0000:05: bus scan returning with max=2f
[   57.691702] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 0
[   57.692799] pci_bus 0000:30: scanning bus
[   57.693896] pci_bus 0000:30: bus scan returning with max=30
[   57.694990] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 0
[   57.696104] pci_bus 0000:39: scanning bus
[   57.697215] pci_bus 0000:39: bus scan returning with max=39
[   57.698335] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 0
[   57.699483] pci_bus 0000:3a: scanning bus
[   57.700636] pci_bus 0000:3a: bus scan returning with max=3a
[   57.701793] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 1
[   57.702972] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 1
[   57.704130] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 1
[   57.705267] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 1
[   57.706379] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 1
[   57.707489] pci_bus 0000:03: bus scan returning with max=3a
[   57.708588] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 1
[   57.709719] pci_bus 0000:03: Allocating resources
[   57.710900] pcieport 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[   57.712049] pcieport 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   57.713234] pcieport 0000:06:04.0: bridge window [io  0x1000-0x0fff] to [bus 08-2e] add_size 1000
[   57.714398] pcieport 0000:06:05.0: bridge window [io  0x1000-0x0fff] to [bus 2f] add_size 1000
[   57.715524] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 2f] add_size 200000
[   57.716658] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 2f] add_size 200000
[   57.717837] pcieport 0000:03:04.0: bridge window [io  0x1000-0x0fff] to [bus 30-38] add_size 1000
[   57.718982] pcieport 0000:03:05.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[   57.720103] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000
[   57.721226] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 39] add_size 200000
[   57.722345] pcieport 0000:03:06.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[   57.723449] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[   57.724567] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[   57.725698] pcieport 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.726822] pcieport 0000:03:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.727936] pcieport 0000:03:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.729062] pcieport 0000:03:06.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.730178] pcieport 0000:03:06.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.731289] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.732414] pcieport 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.733514] pcieport 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.734609] pcieport 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.735702] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.736792] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.737869] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.738933] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   57.739984] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.741022] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   57.742051] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   57.743054] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   57.744033] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   57.744999] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   57.745957] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.746902] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   57.747843] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.748774] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.749710] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   57.750648] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   57.751585] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.752532] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   57.753469] pcieport 0000:06:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   57.754422] pcieport 0000:06:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   57.755372] pcieport 0000:06:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.756315] pcieport 0000:06:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   57.757233] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.758137] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.759044] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   57.759927] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   57.760801] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   57.761657] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   57.762514] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   57.763350] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   57.967245] ata7: SATA link down (SStatus 0 SControl 320)
[   59.870494] ata8: SATA link down (SStatus 111 SControl 320)
[   59.883093] ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
[   59.883940] ata8: irq_stat 0x80000040, connection status changed
[   59.884770] ata8: SError: { CommWake DevExch }
[   59.885575] ata8: hard resetting link
[   62.143952] ata8: COMRESET failed (errno=-32)
[   62.144738] ata8: reset failed (errno=-32), retrying in 8 secs
[   62.450064] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[   62.450861] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[   62.451716] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 0
[   62.452551] pci_bus 0000:03: scanning bus
[   62.453448] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 0
[   62.454306] pci_bus 0000:04: scanning bus
[   62.455160] pci_bus 0000:04: bus scan returning with max=04
[   62.456024] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 0
[   62.456913] pci_bus 0000:05: scanning bus
[   62.457800] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 0
[   62.458717] pci_bus 0000:06: scanning bus
[   62.459734] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 0
[   62.460699] pci_bus 0000:07: scanning bus
[   62.461665] pci_bus 0000:07: bus scan returning with max=07
[   62.462651] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 0
[   62.463657] pci_bus 0000:08: scanning bus
[   62.464713] pci 0000:08:00.0: [8086:1549] type 01 class 0x060400
[   62.465878] pci 0000:08:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   62.467059] pci 0000:08:00.0: supports D1 D2
[   62.468083] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   62.469148] pci 0000:08:00.0: PME# disabled
[   62.481526] pci 0000:08:00.0: scanning [bus 09-2e] behind bridge, pass 0
[   62.482766] pci_bus 0000:09: scanning bus
[   62.483922] pci 0000:09:00.0: [8086:1549] type 01 class 0x060400
[   62.485134] pci 0000:09:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[   62.486332] pci 0000:09:00.0: supports D1 D2
[   62.487383] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   62.488451] pci 0000:09:00.0: PME# disabled
[   62.489735] pci_bus 0000:09: fixups for bus
[   62.490815] pci 0000:08:00.0: PCI bridge to [bus 09-2e]
[   62.491917] pci 0000:08:00.0:   bridge window [mem 0xe4000000-0xedffffff]
[   62.493025] pci 0000:08:00.0:   bridge window [mem 0xc0000000-0xc9ffffff 64bit pref]
[   62.494125] pci 0000:09:00.0: scanning [bus 0a-0a] behind bridge, pass 0
[   62.495374] pci_bus 0000:0a: scanning bus
[   62.496635] pci 0000:0a:00.0: [14e4:1682] type 00 class 0x020000
[   62.497837] pci 0000:0a:00.0: reg 0x10: [mem 0xc0000000-0xc000ffff 64bit pref]
[   62.499036] pci 0000:0a:00.0: reg 0x18: [mem 0xc0010000-0xc001ffff 64bit pref]
[   62.500279] pci 0000:0a:00.0: reg 0x30: [mem 0xe4100000-0xe410ffff pref]
[   62.501668] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
[   62.502775] pci 0000:0a:00.0: PME# disabled
[   62.504013] pci_bus 0000:0a: fixups for bus
[   62.505129] pci 0000:09:00.0: PCI bridge to [bus 0a]
[   62.506238] pci 0000:09:00.0:   bridge window [io  0xf000-0xe4000fff]
[   62.507331] pci 0000:09:00.0:   bridge window [mem 0xe4000000-0xe5ffffff]
[   62.508429] pci 0000:09:00.0:   bridge window [mem 0xc0000000-0xc1ffffff 64bit pref]
[   62.509494] pci_bus 0000:0a: bus scan returning with max=0a
[   62.510558] pci 0000:09:00.0: scanning [bus 0a-0a] behind bridge, pass 1
[   62.511629] pci_bus 0000:09: bus scan returning with max=0a
[   62.512692] pci 0000:08:00.0: scanning [bus 09-2e] behind bridge, pass 1
[   62.513776] pci_bus 0000:08: bus scan returning with max=2e
[   62.514848] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 0
[   62.515927] pci_bus 0000:2f: scanning bus
[   62.516987] pci_bus 0000:2f: bus scan returning with max=2f
[   62.518050] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 1
[   62.519120] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 1
[   62.520174] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 1
[   62.521206] pci_bus 0000:06: bus scan returning with max=2f
[   62.522229] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 1
[   62.523260] pci_bus 0000:05: bus scan returning with max=2f
[   62.524286] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 0
[   62.525325] pci_bus 0000:30: scanning bus
[   62.526358] pci_bus 0000:30: bus scan returning with max=30
[   62.527396] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 0
[   62.528450] pci_bus 0000:39: scanning bus
[   62.529496] pci_bus 0000:39: bus scan returning with max=39
[   62.530544] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 0
[   62.531600] pci_bus 0000:3a: scanning bus
[   62.532647] pci_bus 0000:3a: bus scan returning with max=3a
[   62.533700] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 1
[   62.534767] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 1
[   62.535824] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 1
[   62.536875] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 1
[   62.537919] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 1
[   62.538945] pci_bus 0000:03: bus scan returning with max=3a
[   62.539979] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 1
[   62.541023] pci_bus 0000:03: Allocating resources
[   62.542053] pci 0000:09:00.0: no compatible bridge window for [io  0xf000-0xe4000fff]
[   62.543138] pci 0000:0a:00.0: BAR 0: reserving [mem 0xc0000000-0xc000ffff flags 0x14220c] (d=0, p=0)
[   62.544203] pci 0000:0a:00.0: BAR 2: reserving [mem 0xc0010000-0xc001ffff flags 0x14220c] (d=0, p=0)
[   62.545335] pcieport 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[   62.546420] pcieport 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   62.547572] pci 0000:09:00.0: bridge window [io  0x1000-0x0fff] to [bus 0a] add_size 1000
[   62.548721] pci 0000:09:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.549857] pci 0000:08:00.0: bridge window [io  0x1000-0x0fff] to [bus 09-2e] add_size 1000
[   62.551025] pci 0000:08:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.552178] pcieport 0000:06:04.0: bridge window [io  0x1000-0x0fff] to [bus 08-2e] add_size 1000
[   62.553381] pcieport 0000:06:05.0: bridge window [io  0x1000-0x0fff] to [bus 2f] add_size 1000
[   62.554565] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 2f] add_size 200000
[   62.555754] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 2f] add_size 200000
[   62.556971] pcieport 0000:03:04.0: bridge window [io  0x1000-0x0fff] to [bus 30-38] add_size 1000
[   62.558158] pcieport 0000:03:05.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[   62.559319] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000
[   62.560491] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 39] add_size 200000
[   62.561660] pcieport 0000:03:06.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[   62.562813] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[   62.563990] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[   62.565169] pcieport 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.566363] pcieport 0000:03:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.567569] pcieport 0000:03:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.568778] pcieport 0000:03:06.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.569976] pcieport 0000:03:06.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.571174] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.572372] pcieport 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.573545] pcieport 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.574703] pcieport 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.575837] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.576965] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.578092] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.579203] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   62.580300] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.581392] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   62.582469] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   62.583539] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   62.584605] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   62.585671] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   62.586742] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.587801] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   62.588838] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.589869] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.590884] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   62.591875] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   62.592865] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.593831] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   62.594780] pcieport 0000:06:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.595730] pcieport 0000:06:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.596680] pcieport 0000:06:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.597628] pcieport 0000:06:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.598553] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.599462] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.600371] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   62.601264] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   62.602134] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.602994] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.603854] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   62.604690] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   62.605514] pci 0000:08:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.606348] pci 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
[   62.607164] pci 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
[   62.607973] pci 0000:09:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.608780] pci 0000:09:00.0: BAR 7: can't assign io (size 0x1000)
[   62.609583] pci 0000:09:00.0: BAR 7: can't assign io (size 0x1000)
[   62.610367] pci 0000:09:00.0: PCI bridge to [bus 0a]
[   62.611142] pci 0000:09:00.0:   bridge window [mem 0xe4000000-0xe5ffffff]
[   62.611923] pci 0000:09:00.0:   bridge window [mem 0xc0000000-0xc1ffffff 64bit pref]
[   62.612692] pci 0000:08:00.0: PCI bridge to [bus 09-2e]
[   62.613467] pci 0000:08:00.0:   bridge window [mem 0xe4000000-0xedffffff]
[   62.614258] pci 0000:08:00.0:   bridge window [mem 0xc0000000-0xc9ffffff 64bit pref]
[   62.616427] pcieport 0000:08:00.0: irq 54 for MSI/MSI-X
[   62.617623] pcieport 0000:09:00.0: irq 55 for MSI/MSI-X
[   62.618726] tg3.c:v3.134 (Sep 16, 2013)
[   62.656386] tg3 0000:0a:00.0 eth0: Tigon3 [partno(BCM957762) rev 57766000] (PCI Express) MAC address a8:20:66:3d:4b:b4
[   62.657513] tg3 0000:0a:00.0 eth0: attached PHY is 57765 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[   62.658579] tg3 0000:0a:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   62.659455] tg3 0000:0a:00.0 eth0: dma_rwctrl[00000001] dma_mask[64-bit]
[   62.660553] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[   62.661467] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[   62.662472] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 0
[   62.663431] pci_bus 0000:03: scanning bus
[   62.664440] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 0
[   62.665427] pci_bus 0000:04: scanning bus
[   62.666414] pci_bus 0000:04: bus scan returning with max=04
[   62.667412] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 0
[   62.668428] pci_bus 0000:05: scanning bus
[   62.669456] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 0
[   62.670514] pci_bus 0000:06: scanning bus
[   62.671663] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 0
[   62.672730] pci_bus 0000:07: scanning bus
[   62.673779] pci_bus 0000:07: bus scan returning with max=07
[   62.674827] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 0
[   62.675902] pci_bus 0000:08: scanning bus
[   62.676964] pcieport 0000:08:00.0: scanning [bus 09-2e] behind bridge, pass 0
[   62.678061] pci_bus 0000:09: scanning bus
[   62.679299] pcieport 0000:09:00.0: scanning [bus 0a-0a] behind bridge, pass 0
[   62.680433] pci_bus 0000:0a: scanning bus
[   62.681561] pci_bus 0000:0a: bus scan returning with max=0a
[   62.682709] pcieport 0000:09:00.0: scanning [bus 0a-0a] behind bridge, pass 1
[   62.683884] pci_bus 0000:09: bus scan returning with max=0a
[   62.685073] pcieport 0000:08:00.0: scanning [bus 09-2e] behind bridge, pass 1
[   62.686266] pci_bus 0000:08: bus scan returning with max=2e
[   62.687448] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 0
[   62.688660] pci_bus 0000:2f: scanning bus
[   62.689855] pci_bus 0000:2f: bus scan returning with max=2f
[   62.691048] pcieport 0000:06:03.0: scanning [bus 07-07] behind bridge, pass 1
[   62.692285] pcieport 0000:06:04.0: scanning [bus 08-2e] behind bridge, pass 1
[   62.693509] pcieport 0000:06:05.0: scanning [bus 2f-2f] behind bridge, pass 1
[   62.694719] pci_bus 0000:06: bus scan returning with max=2f
[   62.695930] pcieport 0000:05:00.0: scanning [bus 06-2f] behind bridge, pass 1
[   62.697153] pci_bus 0000:05: bus scan returning with max=2f
[   62.698375] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 0
[   62.699612] pci_bus 0000:30: scanning bus
[   62.700835] pci_bus 0000:30: bus scan returning with max=30
[   62.702071] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 0
[   62.703324] pci_bus 0000:39: scanning bus
[   62.704543] pci_bus 0000:39: bus scan returning with max=39
[   62.705754] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 0
[   62.706961] pci_bus 0000:3a: scanning bus
[   62.708162] pci_bus 0000:3a: bus scan returning with max=3a
[   62.709361] pcieport 0000:03:00.0: scanning [bus 04-04] behind bridge, pass 1
[   62.710580] pcieport 0000:03:03.0: scanning [bus 05-2f] behind bridge, pass 1
[   62.711769] pcieport 0000:03:04.0: scanning [bus 30-38] behind bridge, pass 1
[   62.712936] pcieport 0000:03:05.0: scanning [bus 39-39] behind bridge, pass 1
[   62.714083] pcieport 0000:03:06.0: scanning [bus 3a-3a] behind bridge, pass 1
[   62.715203] pci_bus 0000:03: bus scan returning with max=3a
[   62.716321] pcieport 0000:02:00.0: scanning [bus 03-3a] behind bridge, pass 1
[   62.717451] pci_bus 0000:03: Allocating resources
[   62.718660] pcieport 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[   62.719793] pcieport 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   62.720985] pcieport 0000:09:00.0: bridge window [io  0x1000-0x0fff] to [bus 0a] add_size 1000
[   62.722150] pcieport 0000:09:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.723287] pcieport 0000:08:00.0: bridge window [io  0x1000-0x0fff] to [bus 09-2e] add_size 1000
[   62.724461] pcieport 0000:08:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.725606] pcieport 0000:06:04.0: bridge window [io  0x1000-0x0fff] to [bus 08-2e] add_size 1000
[   62.726776] pcieport 0000:06:05.0: bridge window [io  0x1000-0x0fff] to [bus 2f] add_size 1000
[   62.727907] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 2f] add_size 200000
[   62.729048] pcieport 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 2f] add_size 200000
[   62.730217] pcieport 0000:03:04.0: bridge window [io  0x1000-0x0fff] to [bus 30-38] add_size 1000
[   62.731356] pcieport 0000:03:05.0: bridge window [io  0x1000-0x0fff] to [bus 39] add_size 1000
[   62.732480] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 39] add_size 200000
[   62.733613] pcieport 0000:03:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 39] add_size 200000
[   62.734745] pcieport 0000:03:06.0: bridge window [io  0x1000-0x0fff] to [bus 3a] add_size 1000
[   62.735862] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3a] add_size 200000
[   62.736994] pcieport 0000:03:06.0: bridge window [mem 0x00100000-0x000fffff] to [bus 3a] add_size 200000
[   62.738125] pcieport 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.739254] pcieport 0000:03:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.740387] pcieport 0000:03:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.741516] pcieport 0000:03:06.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.742656] pcieport 0000:03:06.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.743812] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.744975] pcieport 0000:03:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.746109] pcieport 0000:03:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.747223] pcieport 0000:03:06.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.748322] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.749409] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.750490] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.751558] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   62.752607] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.753657] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   62.754691] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   62.755703] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   62.756698] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   62.757676] pcieport 0000:03:06.0: BAR 8: can't assign mem (size 0x200000)
[   62.758660] pcieport 0000:03:06.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.759650] pcieport 0000:03:06.0: BAR 7: can't assign io (size 0x1000)
[   62.760644] pcieport 0000:03:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.761645] pcieport 0000:03:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.762638] pcieport 0000:03:05.0: BAR 7: can't assign io (size 0x1000)
[   62.763614] pcieport 0000:03:04.0: BAR 7: can't assign io (size 0x1000)
[   62.764570] pcieport 0000:03:00.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.765508] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[   62.766433] pcieport 0000:06:05.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[   62.767369] pcieport 0000:06:05.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   62.768298] pcieport 0000:06:04.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.769231] pcieport 0000:06:05.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.770143] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.771045] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.771951] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   62.772833] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   62.773704] pcieport 0000:06:05.0: BAR 8: can't assign mem (size 0x200000)
[   62.774560] pcieport 0000:06:05.0: BAR 9: can't assign mem pref (size 0x200000)
[   62.775417] pcieport 0000:06:05.0: BAR 7: can't assign io (size 0x1000)
[   62.776249] pcieport 0000:06:04.0: BAR 7: can't assign io (size 0x1000)
[   62.777073] pcieport 0000:08:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.777905] pcieport 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
[   62.778723] pcieport 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
[   62.779527] pcieport 0000:09:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   62.780330] pcieport 0000:09:00.0: BAR 7: can't assign io (size 0x1000)
[   62.781133] pcieport 0000:09:00.0: BAR 7: can't assign io (size 0x1000)
[   69.893067] ata8: limiting SATA link speed to 1.5 Gbps
[   69.893851] ata8: hard resetting link
[   72.100560] ata8: SATA link down (SStatus 111 SControl 310)
[   72.101341] ata8: EH complete
[   72.111216] ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
[   72.112036] ata8: irq_stat 0x80000040, connection status changed
[   72.112883] ata8: SError: { CommWake DevExch }
[   72.113712] ata8: limiting SATA link speed to 1.5 Gbps
[   72.114543] ata8: hard resetting link
[   74.320984] ata8: COMRESET failed (errno=-32)
[   74.321816] ata8: reset failed (errno=-32), retrying in 8 secs
[   82.122136] ata8: hard resetting link
[   84.055442] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   84.063362] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   89.058705] ata8: hard resetting link
[   89.519044] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   89.522060] ata8.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[   89.522997] ata8.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   89.532028] ata8.00: configured for UDMA/133
[   89.532969] ata8: EH complete
[   89.533999] scsi 8:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[   89.535148] sd 8:0:0:0: [sdb] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[   89.535152] sd 8:0:0:0: Attached scsi generic sg1 type 0
[   89.537268] sd 8:0:0:0: [sdb] Write Protect is off
[   89.538277] sd 8:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   89.539279] sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   89.540612]  sdb: sdb1
[   89.541774] sd 8:0:0:0: [sdb] Attached SCSI disk
[   89.827653] ata8: exception Emask 0x10 SAct 0x0 SErr 0x41d0002 action 0xe frozen
[   89.828681] ata8: irq_stat 0x80400040, connection status changed
[   89.829710] ata8: SError: { RecovComm PHYRdyChg CommWake 10B8B Dispar DevExch }
[   89.830758] ata8: hard resetting link
[   90.709828] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   90.728993] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   90.730094] ata8.00: revalidation failed (errno=-5)
[   95.714103] ata8: hard resetting link
[   96.175429] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   96.197545] ata8.00: configured for UDMA/133
[   96.198648] ata8: EH complete
[  110.252855] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[  110.253993] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[  110.255164] pcieport 0000:06:05.0: PME# disabled
[  110.256451] tg3 0000:0a:00.0: PME# disabled
[  110.274805] pcieport 0000:09:00.0: PME# disabled
[  110.276073] pcieport 0000:08:00.0: PME# disabled
[  110.277359] pcieport 0000:06:04.0: PME# disabled
[  110.278625] ahci 0000:07:00.0: PME# disabled
[  110.279889] ------------[ cut here ]------------
[  110.281049] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.282158] sysfs group ffffffff81e6f940 not found for kobject 'host7'
[  110.283273] Modules linked in:
[  110.284381] CPU: 0 PID: 978 Comm: kworker/0:2 Not tainted 3.13.0-rc1+ #49
[  110.285513] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.286678] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.287843]  0000000000000009 ffff88006e1bda00 ffffffff8180b8df ffff88006e1bda48
[  110.289029]  ffff88006e1bda38 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.290217]  ffff88006e0b9b58 ffff88006e0b9988 ffff88006e935c28 ffff88006e1bda98
[  110.291404] Call Trace:
[  110.292564]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.293734]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.294899]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.296045]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.297198]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.298339]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.299467]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.300580]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.301697]  [<ffffffff81458d0a>] scsi_remove_host+0xba/0x110
[  110.302809]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.303910]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.304987]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.306061]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.307125]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.308175]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.309214]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.310231]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.311226]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.312223]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.313217]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.314200]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.315161]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.316116]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.317071]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.318008]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.318945]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.319863]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.320780]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.321696]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.322624]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.323579]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.324529]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.325485] ---[ end trace 47aef14bd4d4641e ]---
[  110.326442] ------------[ cut here ]------------
[  110.327414] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.328367] sysfs group ffffffff81e6f940 not found for kobject 'host7'
[  110.329315] Modules linked in:
[  110.330240] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.331171] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.332119] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.333065]  0000000000000009 ffff88006e1bda18 ffffffff8180b8df ffff88006e1bda60
[  110.334040]  ffff88006e1bda50 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.335013]  ffff88006e0b9998 ffff88006df06ed8 ffff88006e935c28 ffff88006e1bdab0
[  110.335990] Call Trace:
[  110.336942]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.337919]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.338900]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.339873]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.340848]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.341826]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.342811]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.343796]  [<ffffffff81458d12>] scsi_remove_host+0xc2/0x110
[  110.344782]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.345768]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.346753]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.347739]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.348730]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.349712]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.350713]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.351719]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.352703]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.353691]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.354692]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.355692]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.356676]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.357661]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.358654]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.359638]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.360628]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.361616]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.362603]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.363594]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.364578]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.365571]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.366558]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.367547] ---[ end trace 47aef14bd4d4641f ]---
[  110.368555] ata8.00: disabled
[  110.369698] ------------[ cut here ]------------
[  110.370728] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.371712] sysfs group ffffffff81e6f940 not found for kobject '8:0:0:0'
[  110.372691] Modules linked in:
[  110.373648] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.374609] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.375590] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.376569]  0000000000000009 ffff88006e1bd9a8 ffffffff8180b8df ffff88006e1bd9f0
[  110.377574]  ffff88006e1bd9e0 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.378577]  ffff88006d42b210 ffff8801003b7948 ffff88006e935c28 ffff88006e1bda40
[  110.379581] Call Trace:
[  110.380560]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.381565]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.382570]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.383565]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.384565]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.385561]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.386562]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.387559]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.388554]  [<ffffffff812bec19>] bsg_unregister_queue+0x59/0xa0
[  110.389553]  [<ffffffff81464499>] __scsi_remove_device+0x99/0xc0
[  110.390546]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.391537]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.392520]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.393517]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.394529]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.395538]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.396546]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.397567]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.398605]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.399631]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.400643]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.401667]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.402691]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.403705]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.404704]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.405699]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.406688]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.407670]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.408653]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.409634]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.410604]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.411576]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.412543]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.413508]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.414451]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.415391] ---[ end trace 47aef14bd4d46420 ]---
[  110.416354] ------------[ cut here ]------------
[  110.417311] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.418228] sysfs group ffffffff81e6f940 not found for kobject '8:0:0:0'
[  110.419135] Modules linked in:
[  110.420030] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.420952] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.421887] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.422827]  0000000000000009 ffff88006e1bd9c0 ffffffff8180b8df ffff88006e1bda08
[  110.423798]  ffff88006e1bd9f8 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.424781]  ffff8801003b7b18 ffff8801003b7948 ffff88006e935c28 ffff88006e1bda58
[  110.425770] Call Trace:
[  110.426734]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.427719]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.428712]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.429701]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.430694]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.431686]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.432679]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.433677]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.434671]  [<ffffffff814644a5>] __scsi_remove_device+0xa5/0xc0
[  110.435668]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.436664]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.437651]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.438639]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.439624]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.440617]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.441631]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.442641]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.443643]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.444642]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.445646]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.446654]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.447664]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.448667]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.449658]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.450646]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.451631]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.452609]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.453590]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.454565]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.455537]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.456514]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.457482]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.458459]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.459415]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.460365] ---[ end trace 47aef14bd4d46421 ]---
[  110.461306] ------------[ cut here ]------------
[  110.462234] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.463172] sysfs group ffffffff81e6f940 not found for kobject 'sg1'
[  110.464095] Modules linked in:
[  110.464998] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.465926] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.466877] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.467821]  0000000000000009 ffff88006e1bd920 ffffffff8180b8df ffff88006e1bd968
[  110.468790]  ffff88006e1bd958 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.469772]  ffff88006d42b810 ffff8801003b7948 0000000000000246 ffff88006e1bd9b8
[  110.470764] Call Trace:
[  110.471731]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.472714]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.473700]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.474681]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.475668]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.476658]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.477646]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.478636]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.479625]  [<ffffffff81441097>] device_destroy+0x37/0x40
[  110.480612]  [<ffffffff81472ace>] sg_remove+0xbe/0x100
[  110.481596]  [<ffffffff81440ee1>] device_del+0xc1/0x1b0
[  110.482574]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.483550]  [<ffffffff814644a5>] __scsi_remove_device+0xa5/0xc0
[  110.484530]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.485520]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.486518]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.487514]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.488502]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.489503]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.490521]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.491537]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.492553]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.493565]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.494570]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.495574]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.496577]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.497565]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.498535]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.499504]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.500467]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.501422]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.502373]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.503323]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.504256]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.505180]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.506090]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.506994]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.507875]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.508733] ---[ end trace 47aef14bd4d46422 ]---
[  110.509698] ------------[ cut here ]------------
[  110.510607] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.511476] sysfs group ffffffff81e6f940 not found for kobject '8:0:0:0'
[  110.512338] Modules linked in:
[  110.513196] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.514079] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.514996] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.515920]  0000000000000009 ffff88006e1bd9d8 ffffffff8180b8df ffff88006e1bda20
[  110.516875]  ffff88006e1bda10 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.517834]  ffff8801003b7958 ffff88006d40ec28 ffff88006e935c28 ffff88006e1bda70
[  110.518795] Call Trace:
[  110.519745]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.520714]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.521693]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.522663]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.523640]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.524614]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.525592]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.526571]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.527556]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.528546]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.529528]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.530507]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.531486]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.532460]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.533450]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.534451]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.535451]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.536431]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.537410]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.538408]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.539410]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.540398]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.541378]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.542356]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.543334]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.544306]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.545280]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.546250]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.547220]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.548193]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.549159]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.550126]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.551093]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.552050] ---[ end trace 47aef14bd4d46423 ]---
[  110.553000] ------------[ cut here ]------------
[  110.553931] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.554881] sysfs group ffffffff81e6f940 not found for kobject '8:0:0:0'
[  110.555813] Modules linked in:
[  110.556725] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.557655] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.558606] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.559556]  0000000000000009 ffff88006e1bd910 ffffffff8180b8df ffff88006e1bd958
[  110.560525]  ffff88006e1bd948 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.561502]  ffff88006d40d420 ffff8801003b7948 ffff88006e935c28 ffff88006e1bd9a8
[  110.562483] Call Trace:
[  110.563452]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.564437]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.565426]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.566405]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.567392]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.568376]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.569359]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.570347]  [<ffffffff8146b4ef>] sd_remove+0x5f/0xd0
[  110.571329]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.572322]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.573315]  [<ffffffff81444290>] bus_remove_device+0x100/0x180
[  110.574306]  [<ffffffff81440f41>] device_del+0x121/0x1b0
[  110.575294]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.576287]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.577294]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.578310]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.579321]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.580326]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.581339]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.582372]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.583405]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.584436]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.585462]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.586475]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.587492]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.588514]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.589519]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.590508]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.591492]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.592473]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.593449]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.594415]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.595385]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.596338]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.597283]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.598213]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.599137]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.600042]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.600929] ---[ end trace 47aef14bd4d46424 ]---
[  110.601818] ------------[ cut here ]------------
[  110.602721] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.603610] sysfs group ffffffff81e6f940 not found for kobject 'sdb1'
[  110.604489] Modules linked in:
[  110.605364] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.606266] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.607205] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.608149]  0000000000000009 ffff88006e1bd8b8 ffffffff8180b8df ffff88006e1bd900
[  110.609125]  ffff88006e1bd8f0 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.610107]  ffff88006df4dc38 ffff88006d40d070 ffff88006e935c28 ffff88006e1bd950
[  110.611095] Call Trace:
[  110.612063]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.613047]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.614037]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.615019]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.616003]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.616989]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.617970]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.618955]  [<ffffffff812ba063>] delete_partition+0x43/0x80
[  110.619942]  [<ffffffff812b8648>] del_gendisk+0xb8/0x290
[  110.620929]  [<ffffffff8146b4fb>] sd_remove+0x6b/0xd0
[  110.621911]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.622900]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.623882]  [<ffffffff81444290>] bus_remove_device+0x100/0x180
[  110.624869]  [<ffffffff81440f41>] device_del+0x121/0x1b0
[  110.625860]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.626870]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.627879]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.628875]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.629881]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.630904]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.631920]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.632941]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.633970]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.634998]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.636013]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.637017]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.638021]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.639025]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.640013]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.640983]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.641951]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.642905]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.643861]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.644803]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.645730]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.646647]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.647556]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.648440]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.649310]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.650160]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.651007] ---[ end trace 47aef14bd4d46425 ]---
[  110.651901] ------------[ cut here ]------------
[  110.652744] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.653604] sysfs group ffffffff81e3b440 not found for kobject 'sdb1'
[  110.654464] Modules linked in:
[  110.655326] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.656216] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.657132] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.658053]  0000000000000009 ffff88006e1bd878 ffffffff8180b8df ffff88006e1bd8c0
[  110.659007]  ffff88006e1bd8b0 ffffffff81044b28 0000000000000000 ffffffff81e3b440
[  110.659972]  ffff88006df4dc38 ffffffff81e5ab40 ffff88006e935c28 ffff88006e1bd910
[  110.660943] Call Trace:
[  110.661888]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.662852]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.663819]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.664780]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.665745]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.666711]  [<ffffffff811b1b3b>] sysfs_remove_groups+0x2b/0x40
[  110.667671]  [<ffffffff81440499>] device_remove_attrs+0x59/0x80
[  110.668635]  [<ffffffff81440f39>] device_del+0x119/0x1b0
[  110.669600]  [<ffffffff812ba063>] delete_partition+0x43/0x80
[  110.670565]  [<ffffffff812b8648>] del_gendisk+0xb8/0x290
[  110.671524]  [<ffffffff8146b4fb>] sd_remove+0x6b/0xd0
[  110.672477]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.673437]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.674395]  [<ffffffff81444290>] bus_remove_device+0x100/0x180
[  110.675359]  [<ffffffff81440f41>] device_del+0x121/0x1b0
[  110.676337]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.677321]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.678299]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.679281]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.680277]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.681276]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.682270]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.683273]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.684275]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.685272]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.686259]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.687232]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.688208]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.689185]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.690150]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.691100]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.692038]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.692980]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.693891]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.694793]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.695690]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.696575]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.697447]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.698290]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.699131]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.699959]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.700785] ---[ end trace 47aef14bd4d46426 ]---
[  110.701662] ------------[ cut here ]------------
[  110.702538] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.703387] sysfs group ffffffff81e3b440 not found for kobject 'sdb'
[  110.704245] Modules linked in:
[  110.705102] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.705984] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.706895] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.707817]  0000000000000009 ffff88006e1bd8e8 ffffffff8180b8df ffff88006e1bd930
[  110.708775]  ffff88006e1bd920 ffffffff81044b28 0000000000000000 ffffffff81e3b440
[  110.709741]  ffff88006d40d080 0000000000800010 ffff88006e935c28 ffff88006e1bd980
[  110.710722] Call Trace:
[  110.711680]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.712651]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.713629]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.714602]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.715578]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.716553]  [<ffffffff810db824>] blk_trace_remove_sysfs+0x14/0x20
[  110.717531]  [<ffffffff812ade80>] blk_unregister_queue+0x60/0x90
[  110.718515]  [<ffffffff812b86b9>] del_gendisk+0x129/0x290
[  110.719498]  [<ffffffff8146b4fb>] sd_remove+0x6b/0xd0
[  110.720480]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.721471]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.722458]  [<ffffffff81444290>] bus_remove_device+0x100/0x180
[  110.723448]  [<ffffffff81440f41>] device_del+0x121/0x1b0
[  110.724434]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.725436]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.726449]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.727455]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.728453]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.729465]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.730490]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.731519]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.732545]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.733582]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.734608]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.735621]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.736636]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.737648]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.738649]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.739634]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.740619]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.741601]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.742569]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.743543]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.744498]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.745438]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.746374]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.747295]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.748206]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.749092]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.749964] ---[ end trace 47aef14bd4d46427 ]---
[  110.750837] ------------[ cut here ]------------
[  110.751694] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.752570] sysfs group ffffffff81e6f940 not found for kobject 'sdb'
[  110.753453] Modules linked in:
[  110.754328] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.755237] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.756175] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.757119]  0000000000000009 ffff88006e1bd8d0 ffffffff8180b8df ffff88006e1bd918
[  110.758095]  ffff88006e1bd908 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.759079]  ffff88006d40d080 ffff8801003b7948 ffff88006e935c28 ffff88006e1bd968
[  110.760071] Call Trace:
[  110.761039]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.762024]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.763014]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.763994]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.764971]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.765955]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.766939]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.767923]  [<ffffffff812b87ef>] del_gendisk+0x25f/0x290
[  110.768906]  [<ffffffff8146b4fb>] sd_remove+0x6b/0xd0
[  110.769892]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.770880]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.771867]  [<ffffffff81444290>] bus_remove_device+0x100/0x180
[  110.772853]  [<ffffffff81440f41>] device_del+0x121/0x1b0
[  110.773838]  [<ffffffff814644b5>] __scsi_remove_device+0xb5/0xc0
[  110.774839]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.775856]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.776863]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.777864]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.778876]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.779900]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.780926]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.781950]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.782977]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.783998]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.785008]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.786019]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.787029]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.788022]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.788995]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.789968]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.790940]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.791899]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.792861]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.793808]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.794738]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.795665]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.796575]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.797472]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.798344]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.799210] ---[ end trace 47aef14bd4d46428 ]---
[  110.853802] sd 8:0:0:0: [sdb] Synchronizing SCSI cache
[  110.854741] sd 8:0:0:0: [sdb]  
[  110.855575] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[  110.856424] sd 8:0:0:0: [sdb] Stopping disk
[  110.857277] sd 8:0:0:0: [sdb] START_STOP FAILED
[  110.858121] sd 8:0:0:0: [sdb]  
[  110.858947] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[  110.859940] ------------[ cut here ]------------
[  110.860825] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.861703] sysfs group ffffffff81e6f940 not found for kobject 'target8:0:0'
[  110.862591] Modules linked in:
[  110.863477] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.864392] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.865336] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.866288]  0000000000000009 ffff88006e1bd8a0 ffffffff8180b8df ffff88006e1bd8e8
[  110.867272]  ffff88006e1bd8d8 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.868265]  ffff88006d40ec38 ffff88006d480188 ffff8801003b7800 ffff88006e1bd938
[  110.869263] Call Trace:
[  110.870243]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.871237]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.872241]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.873235]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.874237]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.875237]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.876231]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.877231]  [<ffffffff81460ad2>] scsi_target_reap_usercontext+0x22/0x30
[  110.878257]  [<ffffffff8105d99f>] execute_in_process_context+0x5f/0x70
[  110.879288]  [<ffffffff81461d4c>] scsi_target_reap+0xbc/0xe0
[  110.880310]  [<ffffffff81463b48>] scsi_device_dev_release_usercontext+0x188/0x1c0
[  110.881359]  [<ffffffff8105d99f>] execute_in_process_context+0x5f/0x70
[  110.882426]  [<ffffffff814639b7>] scsi_device_dev_release+0x17/0x20
[  110.883500]  [<ffffffff8144054d>] device_release+0x2d/0xa0
[  110.884570]  [<ffffffff812c82f7>] kobject_cleanup+0x77/0x1b0
[  110.885643]  [<ffffffff812c81a5>] kobject_put+0x35/0x70
[  110.886711]  [<ffffffff81440812>] put_device+0x12/0x20
[  110.887772]  [<ffffffff81464489>] __scsi_remove_device+0x89/0xc0
[  110.888839]  [<ffffffff81462bc4>] scsi_forget_host+0x64/0x70
[  110.889904]  [<ffffffff81458cae>] scsi_remove_host+0x5e/0x110
[  110.890959]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.892009]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.893053]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.894100]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.895135]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.896168]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.897204]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.898223]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.899223]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.900232]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.901253]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.902261]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.903247]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.904218]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.905174]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.906111]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.907035]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.907943]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.908824]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.909697]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.910555]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.911415]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.912257]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.913106] ---[ end trace 47aef14bd4d46429 ]---
[  110.913993] ------------[ cut here ]------------
[  110.914890] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.915774] sysfs group ffffffff81e6f940 not found for kobject 'host8'
[  110.916659] Modules linked in:
[  110.917541] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.918459] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.919404] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.920351]  0000000000000009 ffff88006e1bda00 ffffffff8180b8df ffff88006e1bda48
[  110.921326]  ffff88006e1bda38 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.922307]  ffff88006d480358 ffff88006d480188 ffff88006e935c28 ffff88006e1bda98
[  110.923283] Call Trace:
[  110.924235]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.925202]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.926177]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.927146]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.928125]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.929104]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.930077]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.931058]  [<ffffffff81440fe9>] device_unregister+0x19/0x60
[  110.932040]  [<ffffffff81458d0a>] scsi_remove_host+0xba/0x110
[  110.933027]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.934011]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.934995]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.935974]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.936955]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.937950]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.938959]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.939955]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.940930]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.941921]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.942929]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.943923]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.944899]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.945882]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.946866]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.947844]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.948826]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.949806]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.950786]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.951767]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.952744]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.953730]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.954703]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.955689] ---[ end trace 47aef14bd4d4642a ]---
[  110.956672] ------------[ cut here ]------------
[  110.957671] WARNING: CPU: 0 PID: 978 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
[  110.958647] sysfs group ffffffff81e6f940 not found for kobject 'host8'
[  110.959621] Modules linked in:
[  110.960571] CPU: 0 PID: 978 Comm: kworker/0:2 Tainted: G        W    3.13.0-rc1+ #49
[  110.961524] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  110.962497] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  110.963466]  0000000000000009 ffff88006e1bda18 ffffffff8180b8df ffff88006e1bda60
[  110.964462]  ffff88006e1bda50 ffffffff81044b28 0000000000000000 ffffffff81e6f940
[  110.965455]  ffff88006d480198 ffff88006d4f2ed8 ffff88006e935c28 ffff88006e1bdab0
[  110.966450] Call Trace:
[  110.967418]  [<ffffffff8180b8df>] dump_stack+0x45/0x56
[  110.968411]  [<ffffffff81044b28>] warn_slowpath_common+0x78/0xa0
[  110.969406]  [<ffffffff81044b97>] warn_slowpath_fmt+0x47/0x50
[  110.970391]  [<ffffffff811b0839>] ? sysfs_get_dirent_ns+0x49/0x70
[  110.971374]  [<ffffffff811b1a76>] sysfs_remove_group+0xc6/0xd0
[  110.972365]  [<ffffffff8144a39e>] dpm_sysfs_remove+0x3e/0x50
[  110.973360]  [<ffffffff81440e60>] device_del+0x40/0x1b0
[  110.974349]  [<ffffffff81458d12>] scsi_remove_host+0xc2/0x110
[  110.975341]  [<ffffffff81476f56>] ata_host_detach+0xc6/0x100
[  110.976332]  [<ffffffff81476fa8>] ata_pci_remove_one+0x18/0x20
[  110.977326]  [<ffffffff812f1638>] pci_device_remove+0x28/0x60
[  110.978317]  [<ffffffff81444944>] __device_release_driver+0x64/0xd0
[  110.979311]  [<ffffffff814449ce>] device_release_driver+0x1e/0x30
[  110.980302]  [<ffffffff812ecaa4>] pci_stop_bus_device+0x94/0xa0
[  110.981305]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.982311]  [<ffffffff812eca4b>] pci_stop_bus_device+0x3b/0xa0
[  110.983304]  [<ffffffff812ecbad>] pci_stop_and_remove_bus_device+0xd/0x20
[  110.984296]  [<ffffffff813050b3>] trim_stale_devices+0x73/0xe0
[  110.985303]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.986312]  [<ffffffff813050fb>] trim_stale_devices+0xbb/0xe0
[  110.987309]  [<ffffffff813054de>] acpiphp_check_bridge+0x7e/0xd0
[  110.988304]  [<ffffffff8130631f>] hotplug_event+0xff/0x240
[  110.989304]  [<ffffffff81306485>] hotplug_event_work+0x25/0x60
[  110.990296]  [<ffffffff8131f3f9>] acpi_hotplug_work_fn+0x17/0x22
[  110.991284]  [<ffffffff8105e11a>] process_one_work+0x17a/0x440
[  110.992274]  [<ffffffff8105ed19>] worker_thread+0x119/0x390
[  110.993263]  [<ffffffff8105ec00>] ? manage_workers.isra.25+0x2a0/0x2a0
[  110.994256]  [<ffffffff81064d0d>] kthread+0xcd/0xf0
[  110.995241]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.996234]  [<ffffffff8181c43c>] ret_from_fork+0x7c/0xb0
[  110.997221]  [<ffffffff81064c40>] ? kthread_create_on_node+0x180/0x180
[  110.998208] ---[ end trace 47aef14bd4d4642b ]---
[  111.499504] ata7: failed to stop engine (-5)
[  112.000839] ata8: failed to stop engine (-5)
[  112.001994] pcieport 0000:06:03.0: PME# disabled
[  112.003058] pcieport 0000:05:00.0: PME# disabled
[  112.004198] pci_bus 0000:07: busn_res: [bus 07] is released
[  112.013864] pci_bus 0000:0a: busn_res: [bus 0a] is released
[  112.014833] pci_bus 0000:09: busn_res: [bus 09-2e] is released
[  112.015789] pci_bus 0000:08: busn_res: [bus 08-2e] is released
[  112.016728] pci_bus 0000:2f: busn_res: [bus 2f] is released
[  112.017658] pci_bus 0000:06: busn_res: [bus 06-2f] is released
[  112.018571] pcieport 0000:03:04.0: PME# disabled
[  112.019548] pci_bus 0000:30: busn_res: [bus 30-38] is released
[  112.020446] pcieport 0000:03:05.0: PME# disabled
[  112.021431] pci_bus 0000:39: busn_res: [bus 39] is released
[  112.022339] pcieport 0000:03:06.0: PME# disabled
[  112.023328] pci_bus 0000:3a: busn_res: [bus 3a] is released
[  112.024263] pcieport 0000:02:00.0: scanning [bus ff-ff] behind bridge, pass 0
[  112.025159] pcieport 0000:02:00.0: bridge configuration invalid ([bus ff-ff]), reconfiguring
[  112.026022] pcieport 0000:02:00.0: scanning [bus ff-ff] behind bridge, pass 1
[  112.026883] pci_bus 0000:03: Allocating resources
[  112.027745] pcieport 0000:03:00.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[  112.028637] pcieport 0000:03:00.0: bridge window [mem 0x00100000-0x000fffff pref] to [bus 04] add_size 200000
[  112.029566] pcieport 0000:03:00.0: res[9]=[mem 0x00100000-0x000fffff pref] get_res_add_size add_size 200000
[  112.030482] pcieport 0000:03:00.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[  112.031409] pcieport 0000:03:00.0: BAR 9: assigned [mem 0xca000000-0xca1fffff pref]
[  112.032352] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[  112.033306] pcieport 0000:03:00.0: BAR 7: can't assign io (size 0x1000)
[  112.034250] pcieport 0000:02:00.0: Max Payload Size 16384, but upstream 0000:00:1c.4 set to 128; if necessary, use "pci=pcie_bus_safe" and report a bug
[  112.036242] pcieport 0000:02:00.0: Max Payload Size 16384, but upstream 0000:00:1c.4 set to 128; if necessary, use "pci=pcie_bus_safe" and report a bug
[  112.038404] pcieport 0000:02:00.0: Max Payload Size 16384, but upstream 0000:00:1c.4 set to 128; if necessary, use "pci=pcie_bus_safe" and report a bug
[  112.040710] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[  112.041889] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[  112.043076] pcieport 0000:03:03.0: PME# disabled
[  112.044380] pcieport 0000:03:00.0: PME# disabled
[  112.045702] pcieport 0000:02:00.0: PME# disabled
[  112.047015] pci_bus 0000:04: busn_res: [bus 04] is released
[  112.048254] pci_bus 0000:05: busn_res: [bus 05-2f] is released
[  112.049505] pci_bus 0000:03: busn_res: [bus 03-3a] is released
[  112.050792] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[  112.052003] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[  112.053145] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP05
[  112.054289] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP05
[  127.969485] random: nonblocking pool is initialized
