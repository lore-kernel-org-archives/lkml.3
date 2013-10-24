Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3JXFxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:53:45 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58752 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3JXFxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
	<CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
	<20131015024452.GA31951@srcf.ucam.org>
	<20131016202123.GA17866@google.com>
	<CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
	<CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
Date: Wed, 23 Oct 2013 22:53:42 -0700
X-Google-Sender-Auth: nGA23hAlOMSlvWkzxhM67S0AQv8
Message-ID: <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 8:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Yinghai]
>
> On Thu, Oct 17, 2013 at 7:59 AM, Andreas Noever
> <andreas.noever@gmail.com> wrote:
>> On Wed, Oct 16, 2013 at 10:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
>>>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
>>>> > [+cc Rafael, Mika, Kirill, linux-pci]
>>>> >
>>>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever
>>>> > <andreas.noever@gmail.com> wrote:
>>>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
>>>> > > crashes a few seconds later. Using
>>>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
>>>> > > to remove a bridge two levels above the device triggers the fault immediately:
>>>> >
>>>> > There have been significant changes in acpiphp related to Thunderbolt
>>>> > since v3.11.
>>>>
>>>> Apple don't expose Thunderbolt via ACPI, so it appears as native PCIe.
>>>> I'd be surprised if acpiphp makes a difference here.
>>>
>>> Yeah, you're right; I wasn't paying attention.
>>>
>>> We save a pci_dev pointer in the pci_pme_list, which of course has a
>>> longer lifetime than the pci_dev itself, but we don't acquire a reference
>>> on it, so I suspect the pci_dev got released before we got around to
>>> doing the pci_pme_list_scan().
>>>
>>> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
>>> should apply to v3.11, too.
>>
>> I have tested your patch against 3.11 where it solves the problem. Thanks!
>>
>> Unfortunately I could not reproduce the problem in 3.12-rc5. I only
>> get the following warning (and no crash):
>>
>> tg3 0000:0a:00.0: PME# disabled
>> pcieport 0000:09:00.0: PME# disabled
>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>> pci_bus 0000:0a: dev 00, dec refcount to 0
>> pci_bus 0000:0a: dev 00, released physical slot 9
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 122 at drivers/pci/pci.c:1430
>> pci_disable_device+0x84/0x90()
>> Device pcieport
>> disabling already-disabled device
>> Modules linked in:
>>  btusb bluetooth joydev hid_apple bcm5974 nls_utf8 nls_cp437 hfsplus
>> vfat fat snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp
>> coretemp kvm_intel kvm cfg80211 uvcvideo crc32_pclmul crc32c_intel
>> videobuf2_vmalloc ghash_clmulni_intel aesni_intel videobuf2_memops
>> aes_x86_64 glue_helper videobuf2_core tg3 videodev lrw gf128mul
>> ablk_helper iTCO_wdt hid_generic iTCO_vendor_support cryptd media
>> applesmc input_polldev usbhid ptp microcode snd_hda_codec_cirrus hid
>> pps_core libphy rfkill i2c_i801 pcspkr snd_hda_intel apple_gmux
>> lib80211 snd_hda_codec acpi_cpufreq snd_hwdep snd_pcm snd_page_alloc
>> snd_timer mei_me snd mei processor soundcore lpc_ich evdev mfd_core
>> apple_bl ac battery ext4 crc16 mbcache jbd2 sd_mod ahci libahci libata
>> xhci_hcd ehci_pci sdhci_pci ehci_hcd sdhci scsi_mod mmc_core
>>  usbcore usb_common nouveau mxm_wmi wmi ttm i915 video button
>> i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
>> CPU: 0 PID: 122 Comm: kworker/u16:5 Not tainted 3.12.0-1-dirty #30
>> Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
>> MBP101.88Z.00EE.B03.1212211437 12/21/2012
>> Workqueue: sysfsd sysfs_schedule_callback_work
>>  0000000000000009 ffff88044c021c00 ffffffff814c4288 ffff88044c021c48
>>  ffff88044c021c38 ffffffff81061b7d ffff880458a5c000 ffffffff8187c5c0
>>  ffff880458a5c000 ffff880458a5b098 0000000000000000 ffff88044c021c98
>> Call Trace:
>>  [<ffffffff814c4288>] dump_stack+0x54/0x8d
>>  [<ffffffff81061b7d>] warn_slowpath_common+0x7d/0xa0
>>  [<ffffffff81061bec>] warn_slowpath_fmt+0x4c/0x50
>>  [<ffffffff812bdd92>] ? do_pci_disable_device+0x52/0x60
>>  [<ffffffff813097f3>] ? acpi_pci_irq_disable+0x4c/0x8d
>>  [<ffffffff812bde24>] pci_disable_device+0x84/0x90
>>  [<ffffffff812cc62a>] pcie_portdrv_remove+0x1a/0x20
>>  [<ffffffff812bfcdb>] pci_device_remove+0x3b/0xb0
>>  [<ffffffff81381caf>] __device_release_driver+0x7f/0xf0
>>  [<ffffffff81381d43>] device_release_driver+0x23/0x30
>>  [<ffffffff813814d8>] bus_remove_device+0x108/0x180
>>  [<ffffffff8137de75>] device_del+0x135/0x1d0
>>  [<ffffffff812ba394>] pci_stop_bus_device+0x94/0xa0
>>  [<ffffffff812ba33b>] pci_stop_bus_device+0x3b/0xa0
>>  [<ffffffff812ba4a2>] pci_stop_and_remove_bus_device+0x12/0x20
>>  [<ffffffff812c15c5>] remove_callback+0x25/0x40
>>  [<ffffffff81212ad4>] sysfs_schedule_callback_work+0x14/0x80
>>  [<ffffffff8107c9e8>] process_one_work+0x178/0x470
>>  [<ffffffff8107d3b1>] worker_thread+0x121/0x3a0
>>  [<ffffffff8107d290>] ? manage_workers.isra.21+0x2b0/0x2b0
>>  [<ffffffff810840f0>] kthread+0xc0/0xd0
>>  [<ffffffff81084030>] ? kthread_create_on_node+0x120/0x120
>>  [<ffffffff814d2dfc>] ret_from_fork+0x7c/0xb0
>>  [<ffffffff81084030>] ? kthread_create_on_node+0x120/0x120
>> ---[ end trace b39a15fa94fbb2a2 ]---
>>
>>
>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
>
> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.

that double disabling should be addressed by:

https://lkml.org/lkml/2013/4/25/608

[PATCH] PCI: Remove duplicate pci_disable_device for pcie port

Thanks

Yinghai
