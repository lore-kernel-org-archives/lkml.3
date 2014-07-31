Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaGaKjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:39:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59284 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbaGaKjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:39:46 -0400
Date: Thu, 31 Jul 2014 12:39:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation
Message-ID: <20140731103941.GA4375@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 08:33:26AM +0800, Jiang Liu wrote:
> Sorry for the incovenience, something is wrong when synchronizing
> the patch. I have found that "pm" should be "power" when building and
> testing this patch on my test machine. And I have also fixed it on
> my development machine, but forgot to do "stg refresh" before "git
> format-patch",

Yeah, use git only :-)

Anyway, still b0rked although I can get further and actually suspend.
Full splat below.

The IOMMU PFs point to

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] RV635 [Radeon HD 3650/3750/4570/4580]

and

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller

respectively.

and the IOPFs are all this OHCI controller. Which points at a timing
problem during suspend, I'm being told, when the device gets returned
to the BIOS but IOMMU is still on and filters accesses. Or something to
that effect. In any case, still b0rked.

-> start suspend to disk:

[   31.422901] hib.sh (3786): drop_caches: 3
[   31.427932] PM: Hibernation mode set to 'shutdown'
[   31.444522] PM: Syncing filesystems ... done.
[   31.452558] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   31.462404] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
[   31.468544] PM: Marking nosave pages: [mem 0xba9b8000-0xbca4dfff]
[   31.474868] PM: Marking nosave pages: [mem 0xbca4f000-0xbcc54fff]
[   31.480995] PM: Marking nosave pages: [mem 0xbd083000-0xbd7f3fff]
[   31.487136] PM: Marking nosave pages: [mem 0xbd800000-0x100000fff]
[   31.493891] PM: Basic memory bitmaps created
[   31.498178] PM: Preallocating image memory... done (allocated 143539 pages)
[   32.001145] PM: Allocated 574156 kbytes in 0.49 seconds (1171.74 MB/s)
[   32.007690] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   33.220531] serial 00:06: activated
[   33.220959] [drm] PCIE gen 2 link speeds already enabled
[   33.228236] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   33.228340] radeon 0000:01:00.0: WB enabled
[   33.228347] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff88042939ac00
[   33.233314] snd_hda_intel 0000:01:00.1: irq 49 for MSI/MSI-X
[   33.259732] [drm] ring test on 0 succeeded in 0 usecs
[   33.259890] [drm] ib test on ring 0 succeeded in 0 usecs
[   33.319713] r8169 0000:02:00.0 eth0: link down
[   33.448144] PM: thaw of devices complete after 229.835 msecs
[   33.455071] PM: writing image.
[   33.535747] ata5: SATA link down (SStatus 0 SControl 300)
[   33.541393] ata6: SATA link down (SStatus 0 SControl 300)
[   33.707603] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   33.714056] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   33.720477] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   33.728938] ata4.00: configured for UDMA/133
[   33.734567] ata3.00: configured for UDMA/133
[   33.739453] ata2.00: configured for UDMA/133
[   33.745111] PM: Using 3 thread(s) for compression.
[   33.745111] PM: Compressing and saving image data (149256 pages)...
[   33.756336] PM: Image saving progress:   0%
[   33.915592] PM: Image saving progress:  10%
[   33.995331] PM: Image saving progress:  20%
[   34.123934] PM: Image saving progress:  30%
[   34.362314] PM: Image saving progress:  40%
[   34.463433] PM: Image saving progress:  50%
[   34.550636] PM: Image saving progress:  60%
[   34.651601] PM: Image saving progress:  70%
[   34.756381] PM: Image saving progress:  80%
[   34.863658] PM: Image saving progress:  90%
[   34.973828] PM: Image saving progress: 100%
[   34.993966] PM: Image saving done.
[   34.998214] PM: Wrote 597024 kbytes in 1.23 seconds (485.38 MB/s)
[   35.005742] PM: S|
[   35.122141] r8169 0000:02:00.0 eth0: link up
[   35.368945] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[   35.376839] sd 3:0:0:0: [sdc] Stopping disk
[   35.898610] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[   35.906277] sd 2:0:0:0: [sdb] Stopping disk
[   36.783830] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   36.792035] sd 1:0:0:0: [sda] Stopping disk
[   36.833993] pcieport 0000:00:04.0: System wakeup enabled by ACPI
[   36.855314] ------------[ cut here ]------------
[   36.862344] WARNING: CPU: 2 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   36.864089] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]
[   36.886423] remove_proc_entry: removing non-empty directory 'irq/23', leaking at least 'ehci_hcd:usb3'
[   36.898325] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   36.934730] CPU: 3 PID: 3786 Comm: hib.sh Not tainted 3.16.0-rc7+ #1
[   36.942103] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   36.953051]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   36.961616]  ffff88041e4ebb78 ffffffff8104f82c ffff880037a91e00 ffff880429842e30
[   36.970232]  0000000000000002 ffff88041e4ebc4e ffff880037a91eb9 ffff88041e4ebbd8
[   36.978822] Call Trace:
[   36.982324]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   36.988496]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   36.995558]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   37.002395]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   37.011279]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   37.020129]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   37.028097]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   37.036478]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   37.045329]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   37.053540]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   37.063012]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   37.071870]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   37.080756]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   37.089838]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   37.098860]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   37.107561]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   37.116425]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   37.125248]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   37.133792]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   37.142348]  [<ffffffff81617455>] power_down+0x45/0xa1
[   37.150335]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   37.158377]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   37.166526]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   37.174858]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   37.183144]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   37.191700]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   37.199609]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   37.207357]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   37.216091] ---[ end trace 555995a6cab7d4fe ]---
[   37.222168] ------------[ cut here ]------------
[   37.227753] WARNING: CPU: 2 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   37.237344] remove_proc_entry: removing non-empty directory 'irq/22', leaking at least 'ohci_hcd:usb7'
[   37.247595] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   37.284164] CPU: 3 PID: 3786 Comm: hib.sh Tainted: G        W     3.16.0-rc7+ #1
[   37.292669] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   37.303684]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   37.312346]  ffff88041e4ebb78 ffffffff8104f82c ffff8804298b7500 ffff880429b2e630
[   37.321035]  0000000000000002 ffff88041e4ebc4e ffff8804298b75b9 ffff88041e4ebbd8
[   37.329713] Call Trace:
[   37.333294]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   37.339569]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   37.346722]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   37.353623]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   37.360688]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   37.367776]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   37.374023]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   37.382851]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   37.392223]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   37.400915]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   37.410875]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   37.420244]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   37.429713]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   37.439354]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   37.448906]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   37.458130]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   37.467572]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   37.476968]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   37.486079]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   37.495206]  [<ffffffff81617455>] power_down+0x45/0xa1
[   37.503789]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   37.512466]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   37.521217]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   37.530104]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   37.538959]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   37.548096]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   37.556513]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   37.564743]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   37.573837] ---[ end trace 555995a6cab7d4ff ]---
[   37.583013] ------------[ cut here ]------------
[   37.588736] WARNING: CPU: 0 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   37.598369] remove_proc_entry: removing non-empty directory 'irq/21', leaking at least 'ehci_hcd:usb2'
[   37.608655] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   37.647451] CPU: 4 PID: 3786 Comm: hib.sh Tainted: G        W     3.16.0-rc7+ #1
[   37.658115] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   37.671304]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   37.682276]  ffff88041e4ebb78 ffffffff8104f82c ffff880429f6c000 ffff880429842e30
[   37.693179]  0000000000000002 ffff88041e4ebc4e ffff880429f6c0b9 ffff88041e4ebbd8
[   37.704132] Call Trace:
[   37.709898]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   37.718393]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   37.727774]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   37.736888]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   37.746167]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   37.755444]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   37.763897]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   37.772742]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   37.782019]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   37.790656]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   37.800534]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   37.809810]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   37.819130]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   37.828650]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   37.838120]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   37.847324]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   37.856698]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   37.866005]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   37.875035]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   37.884060]  [<ffffffff81617455>] power_down+0x45/0xa1
[   37.892580]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   37.901173]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   37.909851]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   37.918705]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   37.927558]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   37.936710]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   37.945157]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   37.953358]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   37.962486] ---[ end trace 555995a6cab7d500 ]---
[   37.971327] ------------[ cut here ]------------
[   37.978904] WARNING: CPU: 2 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   37.990542] remove_proc_entry: removing non-empty directory 'irq/20', leaking at least 'ohci_hcd:usb5'
[   38.002874] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   38.039571] CPU: 3 PID: 3786 Comm: hib.sh Tainted: G        W     3.16.0-rc7+ #1
[   38.048075] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   38.059363]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   38.070381]  ffff88041e4ebb78 ffffffff8104f82c ffff880429843e00 ffff880429b2e630
[   38.081335]  0000000000000002 ffff88041e4ebc4e ffff880429843eb9 ffff88041e4ebbd8
[   38.092303] Call Trace:
[   38.098120]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   38.106619]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   38.115986]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   38.125119]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   38.134401]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   38.143665]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   38.152113]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   38.160971]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   38.170251]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   38.178918]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   38.188836]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   38.198133]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   38.207534]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   38.217056]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   38.226486]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   38.235667]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   38.245025]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   38.254323]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   38.263346]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   38.272404]  [<ffffffff81617455>] power_down+0x45/0xa1
[   38.280890]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   38.289488]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   38.298180]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   38.307040]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   38.315880]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   38.325035]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   38.333471]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   38.341680]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   38.350836] ---[ end trace 555995a6cab7d501 ]---
[   38.359898] ------------[ cut here ]------------
[   38.367518] WARNING: CPU: 6 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   38.377354] remove_proc_entry: removing non-empty directory 'irq/17', leaking at least 'ehci_hcd:usb1'
[   38.387685] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   38.424577] CPU: 7 PID: 3786 Comm: hib.sh Tainted: G        W     3.16.0-rc7+ #1
[   38.433267] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   38.444345]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   38.452997]  ffff88041e4ebb78 ffffffff8104f82c ffff88042b199000 ffff880429842e30
[   38.461711]  0000000000000002 ffff88041e4ebc4e ffff88042b1990b9 ffff88041e4ebbd8
[   38.470362] Call Trace:
[   38.474000]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   38.480276]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   38.487466]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   38.494344]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   38.501441]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   38.508498]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   38.514772]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   38.523647]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   38.532943]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   38.541628]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   38.551512]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   38.560841]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   38.570218]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   38.579774]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   38.589277]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   38.598485]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   38.607886]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   38.617206]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   38.626273]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   38.635346]  [<ffffffff81617455>] power_down+0x45/0xa1
[   38.643849]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   38.652446]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   38.661129]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   38.670047]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   38.678911]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   38.688123]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   38.696609]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   38.704866]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   38.713983] ---[ end trace 555995a6cab7d502 ]---
[   38.722834] ------------[ cut here ]------------
[   38.730422] WARNING: CPU: 0 PID: 3786 at fs/proc/generic.c:521 remove_proc_entry+0x19c/0x1b0()
[   38.740241] remove_proc_entry: removing non-empty directory 'irq/18', leaking at least 'ohci_hcd:usb6'
[   38.750583] Modules linked in: xt_iprange ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4[   38.762023] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
[   38.762030] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
[   38.762034] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   38.762038] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   38.762041] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   38.762044] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   38.762048] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   38.762051] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]

lotta those...

[   45.876957] Clocksource tsc unstable (delta = 4686965640 ns)
[   45.883734]  nf_nat nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 vfat fat fuse dm_crypt dm_mod amd64_edac_mod edac_core fam15h_power k10temp radeon drm_kms_helper ttm acpi_cpufreq r8169
[   45.909515] CPU: 0 PID: 3786 Comm: hib.sh Tainted: G        W     3.16.0-rc7+ #1
[   45.909616] Switched to clocksource acpi_pm
[   45.921887] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[   45.932301]  0000000000000009 ffff88041e4ebb40 ffffffff81617d4e ffff88041e4ebb88
[   45.940316]  ffff88041e4ebb78 ffffffff8104f82c ffff880429842e00 ffff880429b2e630
[   45.948346]  0000000000000002 ffff88041e4ebc4e ffff880429842eb9 ffff88041e4ebbd8
[   45.956357] Call Trace:
[   45.959304]  [<ffffffff81617d4e>] dump_stack+0x4e/0x7a
[   45.964975]  [<ffffffff8104f82c>] warn_slowpath_common+0x8c/0xc0
[   45.971491]  [<ffffffff8104f8ac>] warn_slowpath_fmt+0x4c/0x50
[   45.977757]  [<ffffffff811dc11c>] remove_proc_entry+0x19c/0x1b0
[   45.984240]  [<ffffffff810b479e>] unregister_irq_proc+0xce/0xf0
[   45.990696]  [<ffffffff810ae689>] free_desc+0x39/0x90
[   45.996299]  [<ffffffff810ae729>] irq_free_descs+0x49/0x90
[   46.002380]  [<ffffffff810b3f36>] irq_dispose_mapping+0x36/0x60
[   46.008893]  [<ffffffff8103c2d2>] mp_unmap_irq+0x92/0xc0
[   46.014794]  [<ffffffff81033a81>] acpi_unregister_gsi_ioapic+0x31/0x40
[   46.021911]  [<ffffffff81033987>] acpi_unregister_gsi+0x17/0x20
[   46.028427]  [<ffffffff81340c44>] acpi_pci_irq_disable+0x5c/0x63
[   46.035046]  [<ffffffff81532b6e>] pcibios_disable_device+0x2e/0x40
[   46.041809]  [<ffffffff8130bb22>] do_pci_disable_device+0x52/0x60
[   46.048495]  [<ffffffff8130bb88>] pci_disable_device+0x58/0xd0
[   46.054996]  [<ffffffff81459182>] usb_hcd_pci_shutdown+0x42/0x50
[   46.061611]  [<ffffffff8130db28>] pci_device_shutdown+0x28/0x40
[   46.068202]  [<ffffffff813cf112>] device_shutdown+0xd2/0x1f0
[   46.074543]  [<ffffffff810754b5>] kernel_power_off+0x35/0x80
[   46.080886]  [<ffffffff81617455>] power_down+0x45/0xa1
[   46.086695]  [<ffffffff810a527d>] hibernate+0x19d/0x1d0
[   46.092603]  [<ffffffff810a1c9c>] state_store+0xec/0x100
[   46.098599]  [<ffffffff812d448f>] kobj_attr_store+0xf/0x20
[   46.104755]  [<ffffffff811e91d0>] sysfs_kf_write+0x50/0x70
[   46.110921]  [<ffffffff811e84e5>] kernfs_fop_write+0x105/0x190
[   46.117434]  [<ffffffff81171dcd>] vfs_write+0xbd/0x1d0
[   46.123291]  [<ffffffff81172942>] SyS_write+0x52/0xc0
[   46.129069]  [<ffffffff81620216>] system_call_fastpath+0x1a/0x1f
[   46.135798] ---[ end trace 555995a6cab7d503 ]---
[   46.142058] ACPI: Preparing to enter system sleep state S5
[   46.148449] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[   46.159388] reboot: Power down
[   46.163504] acpi_power_off called

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
