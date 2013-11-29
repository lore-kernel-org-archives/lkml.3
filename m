Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3K2I2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:28:19 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46754 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K2I2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:28:17 -0500
Message-ID: <52985041.5050000@gmail.com>
Date: Fri, 29 Nov 2013 09:28:49 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan>
In-Reply-To: <1821758.2MoNI3h1Mv@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/25/2013 11:47 AM, Rafael J. Wysocki wrote:
> On Monday, November 25, 2013 08:42:21 AM Francis Moreau wrote:
>> On 11/24/2013 10:06 PM, Rafael J. Wysocki wrote:
>>> On Sunday, November 24, 2013 10:39:20 AM Francis Moreau wrote:
>>>> Hello Thomas
>>>>
>>>> On 11/22/2013 11:27 PM, Thomas Gleixner wrote:
>>>>> On Fri, 22 Nov 2013, Rafael J. Wysocki wrote:
>>>>>> On Friday, November 22, 2013 10:36:23 PM Francis Moreau wrote:
>>>>>>> Ok, I've finally managed to find out the bad commit:
>>>>>>> ad07277e82dedabacc52c82746633680a3187d25: ACPI / PM: Hold acpi_scan_lock
>>>>>>> over system PM transitions
>>>>>>>
>>>>>>> I verified that the parent commit doesn't have the problem.
>>>>>>
>>>>>> Interesting.
>>>>>>
>>>>>>> Rafael, you're the man now ;)
>>>>>>
>>>>>> I kind of don't see how that commit may result in behavior that you
>>>>>> described earlier in the thread.
>>>>>>
>>>>>> You get a memory corruption that seems to have started to happen because
>>>>>> we're holding an additional lock over suspend resume now.  Something's fishy
>>>>>> on that machine and we need to figure out what it is.
>>>>>
>>>>> The hickup happens in the timer softirq.
>>>>>
>>>>> @Francis: Did you try to enable DEBUG_OBJECTS.*. If not please give it
>>>>> 	  a try.
>>>>
>>>> This looks like it was a good idea.
>>>>
>>>> The kernel now outputs the following traces after resuming.
>>>>
>>>> [   26.973928] WARNING: CPU: 0 PID: 4 at lib/debugobjects.c:260
>>>> debug_print_object+0x83/0xa0()
>>>> [   26.973932] ODEBUG: free active (active state 0) object type:
>>>> timer_list hint: delayed_work_timer_fn+0x0/0x20
>>>> [   26.973972] Modules linked in: x86_pkg_temp_thermal intel_powerclamp
>>>> rtsx_pci_ms coretemp memstick kvm_intel i2c_i801 iTCO_wdt
>>>> iTCO_vendor_support i915 i2c_algo_bit intel_agp intel_gtt drm_kms_helper
>>>> r8169 drm kvm mii agpgart i2c_core lpc_ich ac shpchp crc32c_intel
>>>> battery thermal wmi evdev mei_me video mei button mperf processor
>>>> serio_raw microcode ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod
>>>> usb_storage rtsx_pci_sdmmc mmc_core ahci libahci libata ehci_pci
>>>> ehci_hcd xhci_hcd scsi_mod rtsx_pci usbcore usb_common
>>>> [   26.974013] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted
>>>> 3.11.0-rc2-ARCH #64
>>>> [   26.974014] Hardware name: CLEVO CO.                        W55xEU
>>>>                        /W55xEU                          , BIOS 4.6.5
>>>> 03/05/2013
>>>> [   26.974019] Workqueue: kacpi_hotplug hotplug_event_work
>>>> [   26.974020]  0000000000000009 ffff880407d0da18 ffffffff81459fe9
>>>> ffff880407d0da60
>>>> [   26.974023]  ffff880407d0da50 ffffffff8104dc7d ffff880407fad488
>>>> ffffffff81836fc0
>>>> [   26.974025]  ffffffff81701358 ffffffff81afef70 0000000000000003
>>>> ffff880407d0dab0
>>>> [   26.974027] Call Trace:
>>>> [   26.974031]  [<ffffffff81459fe9>] dump_stack+0x54/0x8d
>>>> [   26.974043]  [<ffffffff8104dc7d>] warn_slowpath_common+0x7d/0xa0
>>>> [   26.974044]  [<ffffffff8104dcec>] warn_slowpath_fmt+0x4c/0x50
>>>> [   26.974047]  [<ffffffff81261433>] debug_print_object+0x83/0xa0
>>>> [   26.974050]  [<ffffffff8106b820>] ? queue_work_on+0x50/0x50
>>>> [   26.974053]  [<ffffffff81261c2b>] __debug_check_no_obj_freed+0x1fb/0x240
>>>> [   26.974059]  [<ffffffffa008e959>] ? rtsx_pci_remove+0x119/0x1d0
>>>> [rtsx_pci]
>>>
>>> So a device driven by rtsx_pcr.c is removed after resume.  Without the commit
>>> you've bisected it is removed as well, but that happens during resume, so
>>> rtsx_pci_resume() is likely not called in that case.
>>
>> I'm not sure to understand your point.
> 
> The problem is that with the commit you've bisected, the whole removal of
> rtsx_pcr is likely done *before* the PM core calls resume callbacks of
> device drivers (although only incidentally, because it very well may be
> done in parallel with that).  However, after that commit the removal is only
> done after the resume callbacks have been called, which means that the device
> is not physically present when rtsx_pci_resume() is called.  Of course,
> it may not be physically present at that point anyway, so rtsx_pci_resume()
> should have taken that into consideration already, but it doesn't from what
> I can say.
> 

Since it seems to be related to rtsx driver or its upper layer, could
the folks involved in this area have a look to this issue please ?

Thank you

