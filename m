Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3AUXQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:16:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48288 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AUXQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:16:34 -0500
Date: Tue, 22 Jan 2013 00:19:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andre Przywara <andre@andrep.de>, cpufreq@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: more cpufreq funsies
Message-ID: <20130121231929.GA5192@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Andre Przywara <andre@andrep.de>,
	cpufreq@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <20130120105613.GA16519@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130120105613.GA16519@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 11:56:13AM +0100, Borislav Petkov wrote:
> Hi,
> 
> anyone seen this already? I've got this this morning when resuming
> and this is -rc4+ (+ tip/master) but without any other cpufreq and
> powernow-k8 patches.
> 
> It says below "[last unloaded: acpi_cpufreq]" because I played with
> loading and unloading powernow-k8 and acpi-cpufreq yesterday but ...
> 
> Oh, ok, I think I know how it happens: just did a quick test:
> 
> $ rmmod acpi-cpufreq
> $ modprobe powernow-k8
> 
> <suspend-to-disk... resume>
> 
> and get the below dmesg. Oh well, I need to go stare at this when I get
> a chance.

Ok, I think I know what happens:

$ rmmod acpi-cpufreq

The relevant thing to mention here is that cpufreq_unregister_driver()
calls subsys_interface_unregister(&cpufreq_interface) which removes the
whole /sys/devices/system/cpu/cpu?/cpufreq hierarchy.

However, the cpufreq_stats module remains loaded and dangling and it
actually shouldn't make any sense to have cpufreq_stats module loaded
while no cpufreq driver is present, right?

Then, when we modprobe acpi-cpufreq back, the aforementioned hierarchy
is created except the stats/ stuff from cpufreq_stats.

And then, when we suspend the box, it does
cpufreq_stat_cpu_callback->cpufreq_stats_free_sysfs which has already
been freed and thus it triggers the warning below, i.e. the 'stats'
sysfs_dirent is gone.

The way I see it now, a proper fix would be to remove the cpufreq_stats
module along with any cpufreq driver in the unregister path in
cpufreq_unregister_driver() but I don't know how to do that right now.

Or, when we modprobe a cpufreq driver again, to call the
notifier_policy_block to re-create the stats table.

Hmm, I need to stare at code again and try stuff...

> [48790.833251] powernow-k8: this CPU is not supported anymore, using acpi-cpufreq instead.
> [48790.840895] acpi-cpufreq: overriding BIOS provided _PSD data
> [48802.496276] PM: Syncing filesystems ... done.
> [48802.502348] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [48802.518896] PM: Preallocating image memory... done (allocated 469105 pages)
> [48803.006148] PM: Allocated 1876420 kbytes in 0.48 seconds (3909.20 MB/s)
> [48803.006757] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [48803.023243] serial 00:0a: disabled
> [48803.023949] serial 00:0a: System wakeup disabled by ACPI
> [48803.024636] i8042 kbd 00:09: System wakeup enabled by ACPI
> [48803.251740] PM: freeze of devices complete after 229.936 msecs
> [48803.253655] PM: late freeze of devices complete after 1.888 msecs
> [48803.259418] PM: noirq freeze of devices complete after 5.740 msecs
> [48803.259440] Disabling non-boot CPUs ...
> [48803.259567] ------------[ cut here ]------------
> [48803.259589] WARNING: at fs/sysfs/group.c:142 sysfs_remove_group+0x102/0x110()
> [48803.259611] Hardware name: To be filled by O.E.M.
> [48803.259627] sysfs group ffffffffa003e9c0 not found for kobject 'cpufreq'
> [48803.259648] Modules linked in: acpi_cpufreq tun fuse mperf cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative ipv6 kvm_amd kvm aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul microcode radeon edac_core k10temp ohci_hcd ehci_pci fam15h_power ehci_hcd drm_kms_helper r8169 ttm cfbfillrect xhci_hcd cfbimgblt cfbcopyarea [last unloaded: acpi_cpufreq]
> [48803.259841] Pid: 17699, comm: hib.sh Tainted: G        W    3.8.0-rc4+ #2
> [48803.259862] Call Trace:
> [48803.259878]  [<ffffffff811ad900>] ? sysfs_remove_group+0x40/0x110
> [48803.259905]  [<ffffffff8103ae9f>] warn_slowpath_common+0x7f/0xc0
> [48803.259934]  [<ffffffff8103af96>] warn_slowpath_fmt+0x46/0x50
> [48803.259958]  [<ffffffff811abd54>] ? sysfs_get_dirent+0x54/0x80
> [48803.259983]  [<ffffffff811ad9c2>] sysfs_remove_group+0x102/0x110
> [48803.260010]  [<ffffffffa003e7d9>] cpufreq_stats_free_sysfs+0x36/0x49 [cpufreq_stats]
> [48803.260041]  [<ffffffffa003e826>] cpufreq_stat_cpu_callback+0x3a/0x4a [cpufreq_stats]
> [48803.260069]  [<ffffffff8106c26d>] notifier_call_chain+0x5d/0x110
> [48803.260093]  [<ffffffff8106c32e>] __raw_notifier_call_chain+0xe/0x10
> [48803.260116]  [<ffffffff8103ea70>] __cpu_notify+0x20/0x40
> [48803.260138]  [<ffffffff81552dbd>] _cpu_down+0x7d/0x2e0
> [48803.260159]  [<ffffffff815602b9>] ? printk+0x4d/0x4f
> [48803.260180]  [<ffffffff8103ee5d>] disable_nonboot_cpus+0x7d/0x110
> [48803.260204]  [<ffffffff810867e3>] hibernation_snapshot+0x1e3/0x310
> [48803.260227]  [<ffffffff81086fe7>] hibernate+0x127/0x1a0
> [48803.260248]  [<ffffffff81084d54>] state_store+0xe4/0xf0
> [48803.260270]  [<ffffffff81290cef>] kobj_attr_store+0xf/0x20
> [48803.260292]  [<ffffffff811aa4a0>] sysfs_write_file+0xe0/0x150
> [48803.260316]  [<ffffffff8113978b>] vfs_write+0xab/0x170
> [48803.260338]  [<ffffffff81139ab5>] sys_write+0x55/0xa0
> [48803.260360]  [<ffffffff8156af06>] system_call_fastpath+0x1a/0x1f
> [48803.260399] ---[ end trace 56117296a40723c9 ]---
> [48803.266125] smpboot: CPU 1 is now offline

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
