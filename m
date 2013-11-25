Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3KYKfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:35:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53239 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752780Ab3KYKfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:35:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Date: Mon, 25 Nov 2013 11:47:47 +0100
Message-ID: <1821758.2MoNI3h1Mv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5292FF5D.1050304@gmail.com>
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 08:42:21 AM Francis Moreau wrote:
> On 11/24/2013 10:06 PM, Rafael J. Wysocki wrote:
> > On Sunday, November 24, 2013 10:39:20 AM Francis Moreau wrote:
> >> Hello Thomas
> >>
> >> On 11/22/2013 11:27 PM, Thomas Gleixner wrote:
> >>> On Fri, 22 Nov 2013, Rafael J. Wysocki wrote:
> >>>> On Friday, November 22, 2013 10:36:23 PM Francis Moreau wrote:
> >>>>> Ok, I've finally managed to find out the bad commit:
> >>>>> ad07277e82dedabacc52c82746633680a3187d25: ACPI / PM: Hold acpi_scan_lock
> >>>>> over system PM transitions
> >>>>>
> >>>>> I verified that the parent commit doesn't have the problem.
> >>>>
> >>>> Interesting.
> >>>>
> >>>>> Rafael, you're the man now ;)
> >>>>
> >>>> I kind of don't see how that commit may result in behavior that you
> >>>> described earlier in the thread.
> >>>>
> >>>> You get a memory corruption that seems to have started to happen because
> >>>> we're holding an additional lock over suspend resume now.  Something's fishy
> >>>> on that machine and we need to figure out what it is.
> >>>
> >>> The hickup happens in the timer softirq.
> >>>
> >>> @Francis: Did you try to enable DEBUG_OBJECTS.*. If not please give it
> >>> 	  a try.
> >>
> >> This looks like it was a good idea.
> >>
> >> The kernel now outputs the following traces after resuming.
> >>
> >> [   26.973928] WARNING: CPU: 0 PID: 4 at lib/debugobjects.c:260
> >> debug_print_object+0x83/0xa0()
> >> [   26.973932] ODEBUG: free active (active state 0) object type:
> >> timer_list hint: delayed_work_timer_fn+0x0/0x20
> >> [   26.973972] Modules linked in: x86_pkg_temp_thermal intel_powerclamp
> >> rtsx_pci_ms coretemp memstick kvm_intel i2c_i801 iTCO_wdt
> >> iTCO_vendor_support i915 i2c_algo_bit intel_agp intel_gtt drm_kms_helper
> >> r8169 drm kvm mii agpgart i2c_core lpc_ich ac shpchp crc32c_intel
> >> battery thermal wmi evdev mei_me video mei button mperf processor
> >> serio_raw microcode ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod
> >> usb_storage rtsx_pci_sdmmc mmc_core ahci libahci libata ehci_pci
> >> ehci_hcd xhci_hcd scsi_mod rtsx_pci usbcore usb_common
> >> [   26.974013] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted
> >> 3.11.0-rc2-ARCH #64
> >> [   26.974014] Hardware name: CLEVO CO.                        W55xEU
> >>                        /W55xEU                          , BIOS 4.6.5
> >> 03/05/2013
> >> [   26.974019] Workqueue: kacpi_hotplug hotplug_event_work
> >> [   26.974020]  0000000000000009 ffff880407d0da18 ffffffff81459fe9
> >> ffff880407d0da60
> >> [   26.974023]  ffff880407d0da50 ffffffff8104dc7d ffff880407fad488
> >> ffffffff81836fc0
> >> [   26.974025]  ffffffff81701358 ffffffff81afef70 0000000000000003
> >> ffff880407d0dab0
> >> [   26.974027] Call Trace:
> >> [   26.974031]  [<ffffffff81459fe9>] dump_stack+0x54/0x8d
> >> [   26.974043]  [<ffffffff8104dc7d>] warn_slowpath_common+0x7d/0xa0
> >> [   26.974044]  [<ffffffff8104dcec>] warn_slowpath_fmt+0x4c/0x50
> >> [   26.974047]  [<ffffffff81261433>] debug_print_object+0x83/0xa0
> >> [   26.974050]  [<ffffffff8106b820>] ? queue_work_on+0x50/0x50
> >> [   26.974053]  [<ffffffff81261c2b>] __debug_check_no_obj_freed+0x1fb/0x240
> >> [   26.974059]  [<ffffffffa008e959>] ? rtsx_pci_remove+0x119/0x1d0
> >> [rtsx_pci]
> > 
> > So a device driven by rtsx_pcr.c is removed after resume.  Without the commit
> > you've bisected it is removed as well, but that happens during resume, so
> > rtsx_pci_resume() is likely not called in that case.
> 
> I'm not sure to understand your point.

The problem is that with the commit you've bisected, the whole removal of
rtsx_pcr is likely done *before* the PM core calls resume callbacks of
device drivers (although only incidentally, because it very well may be
done in parallel with that).  However, after that commit the removal is only
done after the resume callbacks have been called, which means that the device
is not physically present when rtsx_pci_resume() is called.  Of course,
it may not be physically present at that point anyway, so rtsx_pci_resume()
should have taken that into consideration already, but it doesn't from what
I can say.

I'll try to prepare a debug patch for you later today.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
