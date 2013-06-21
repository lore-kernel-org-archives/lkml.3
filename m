Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161363Ab3FUMij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:38:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45406 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196Ab3FUMih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:38:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
Date: Fri, 21 Jun 2013 14:47:56 +0200
Message-ID: <1620890.UBBDKT8mbZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAN_LGv2kZy_8SrKae5YUwHoUM+mf1OgH2HkAEtiC+ojKCFYSeg@mail.gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <1436701.V8egnZxOqz@vostro.rjw.lan> <CAN_LGv2kZy_8SrKae5YUwHoUM+mf1OgH2HkAEtiC+ojKCFYSeg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 10:36:05 AM Alexander E. Patrakov wrote:
> 2013/6/21 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, June 19, 2013 11:18:41 AM Alexander E. Patrakov wrote:
> >> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > OK, let's try to untangle this a bit.
> >> >
> >> > If you applyt patches [1/4] and [4/4] from the $subject series only, what
> >> > does remain unfixed?
> >>
> >> [not tested, can do so in 12 hours if needed]
> >>
> >> I think there will be problems on undocking and/or on the second
> >> docking, as described in comments #6 - #8 of
> >> https://bugzilla.kernel.org/show_bug.cgi?id=59501
> >
> > OK, I think I have something that might work.  It may not solve all problems,
> > but maybe it helps a bit.  Unfortunately, I can't really test it, so please do
> > if you can.
> >
> > Please apply [1/4] and [4/4] and the one below and see what happens.
> 
> Tested on top of 3.10-rc6.
> 
> Attached dmesg output for the following testcase: boot undocked, dock,
> undock, dock.
> 
> The initial dock went OK. The subsequent undock resulted in the blue
> led on the dock cable turning off quickly, but in PCI devices slowly,
> one-by-one, disappearing from the bus. Also, there were "acpi_handle
> corrupt" messages in dmesg. The subsequent dock resulted in no devices
> added to the bus. So - your patch is not a good replacement for
> patches 2 and 3 in the original series.

Well, this particular patch maybe not, but I like the direction better.

Here's the relevant piece of your dmesg:

[   43.635516] ACPI: \_SB_.DOCK: undocking
[   44.108267] acpiphp_glue: _handle_hotplug_event_func: Device eject notify on \_SB_.PCI0.RP07.LPMB
[   44.110349] xhci_hcd 0000:1b:00.0: remove, state 4
[   44.110497] usb usb6: USB disconnect, device number 1
[   44.112203]  port1: Oops, 'acpi_handle' corrupt
[   44.112242]  port2: Oops, 'acpi_handle' corrupt

What happens here is that USB ports are in the list of dock dependent devices,
but they don't have the ops pointer set, so dock_remove_acpi_device() will be
called for them *before* the usual USB teardown is triggered from the
acpiphp_glue code for their parent.  I *think* the solution may be to simply
skip those things from ds->dependent_list (as they depend on something already
in that list anyway).

I'll attach an updated patch with that change to the bug entry.

[   44.112332] xHCI xhci_drop_endpoint called for root hub
[   44.112334] xHCI xhci_check_bandwidth called for root hub
[   44.114313] usb usb6: Oops, 'acpi_handle' corrupt

Same thing again.

[   44.114349] xhci_hcd 0000:1b:00.0: Host not halted after 16000 microseconds.
[   44.114351] xhci_hcd 0000:1b:00.0: USB bus 6 deregistered
[   44.114360] xhci_hcd 0000:1b:00.0: remove, state 4
[   44.114392] usb usb5: USB disconnect, device number 1
[   44.114394] usb 5-1: USB disconnect, device number 2
[   49.120740] xhci_hcd 0000:1b:00.0: Timeout while waiting for configure endpoint command
[   49.120750] xhci_hcd 0000:1b:00.0: Stopped the command ring failed, maybe the host is dead
[   49.120757] xhci_hcd 0000:1b:00.0: Host not halted after 16000 microseconds.
[   49.120759] xhci_hcd 0000:1b:00.0: Abort command ring failed
[   49.120760] xhci_hcd 0000:1b:00.0: HC died; cleaning up
[   49.122075] xHCI xhci_drop_endpoint called for root hub
[   49.122076] xHCI xhci_check_bandwidth called for root hub
[   49.123825] usb usb5: Oops, 'acpi_handle' corrupt

Same thing again.

[   49.123906] xhci_hcd 0000:1b:00.0: Host not halted after 16000 microseconds.
[   49.124208] xhci_hcd 0000:1b:00.0: USB bus 5 deregistered
[   52.150756] ata8.00: disabled
[   52.172219] r8169 0000:19:00.0 enp25s0: rtl_counters_cond == 1 (loop: 1000, delay: 10).
[   52.182516] r8169 0000:19:00.0 enp25s0: rtl_chipcmd_cond == 1 (loop: 100, delay: 100).
[   52.188939] r8169 0000:19:00.0 enp25s0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
[   52.189542] r8169 0000:19:00.0 enp25s0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
[   52.190191] r8169 0000:19:00.0 enp25s0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
[   52.190746] r8169 0000:19:00.0 enp25s0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
[   52.191299] r8169 0000:19:00.0 enp25s0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
[   52.212009] r8169 0000:19:00.0 (unregistered net_device): rtl_eriar_cond == 1 (loop: 100, delay: 100).
[   52.222185] r8169 0000:19:00.0 (unregistered net_device): rtl_eriar_cond == 1 (loop: 100, delay: 100).
[   52.232357] r8169 0000:19:00.0 (unregistered net_device): rtl_eriar_cond == 1 (loop: 100, delay: 100).
[   52.242529] r8169 0000:19:00.0 (unregistered net_device): rtl_eriar_cond == 1 (loop: 100, delay: 100).
[   52.260158] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none
[   52.265799] [drm] radeon: finishing device.
[   52.265804] [drm] Disabling audio support
[   52.267668] radeon 0000:16:00.0: ffff880251e28400 unpin not necessary
[   52.268033] [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
[   52.268164] [TTM] Finalizing pool allocator
[   52.268340] [TTM] Finalizing DMA pool allocator

The thing below looks like a radeon problem?

[   52.268389] ------------[ cut here ]------------
[   52.268395] WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc_dma.c:533 ttm_dma_free_pool+0x101/0x110 [ttm]()
[   52.268396] Modules linked in: ata_generic pata_acpi pata_marvell radeon ttm zram(C) rfcomm bnep rtsx_pci_ms rtsx_pci_sdmmc mmc_core memstick iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm joydev pcspkr i2c_i801 uvcvideo qcserial usb_wwan videobuf2_vmalloc videobuf2_memops videobuf2_core usbserial btusb videodev bluetooth arc4 media iwldvm mac80211 snd_hda_codec_hdmi iwlwifi r8169 rtsx_pci mii cfg80211 snd_hda_codec_realtek i915 sony_laptop rfkill intel_agp snd_hda_intel intel_gtt snd_hda_codec i2c_algo_bit snd_hwdep drm_kms_helper snd_pcm snd_page_alloc drm snd_timer agpgart lpc_ich snd mfd_core sha256_ssse3 sha256_generic dm_crypt raid0 md_mod crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd xhci_hcd ehci_pci ehci_hcd dm_mirror
[   52.268444]  dm_region_hash dm_log dm_mod [last unloaded: microcode]
[   52.268449] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G         C   3.10.0-rc6-rafael #1
[   52.268450] Hardware name: Sony Corporation VPCZ23A4R/VAIO, BIOS R1013H5 05/21/2012
[   52.268455] Workqueue: kacpi_hotplug _handle_hotplug_event_func
[   52.268456]  ffffffffa081f268 ffff8802540d38b8 ffffffff8165af98 ffff8802540d38f8
[   52.268460]  ffffffff8103c8cb ffff8802540d38c8 ffff880251f53700 ffff8802513e23c0
[   52.268463]  0000000000000008 ffff880253d02530 ffff880254079730 ffff8802540d3908
[   52.268466] Call Trace:
[   52.268470]  [<ffffffff8165af98>] dump_stack+0x19/0x1b
[   52.268474]  [<ffffffff8103c8cb>] warn_slowpath_common+0x6b/0xa0
[   52.268476]  [<ffffffff8103c915>] warn_slowpath_null+0x15/0x20
[   52.268480]  [<ffffffffa081cd01>] ttm_dma_free_pool+0x101/0x110 [ttm]
[   52.268484]  [<ffffffffa081dee5>] ttm_dma_page_alloc_fini+0x85/0xcc [ttm]
[   52.268487]  [<ffffffffa0813455>] ttm_mem_global_release+0x25/0xa0 [ttm]
[   52.268497]  [<ffffffffa08494ed>] radeon_ttm_mem_global_release+0xd/0x10 [radeon]
[   52.268507]  [<ffffffffa0176213>] drm_global_item_unref+0x63/0x90 [drm]
[   52.268514]  [<ffffffffa084a721>] radeon_ttm_fini+0xd1/0xe0 [radeon]
[   52.268522]  [<ffffffffa084b129>] radeon_bo_fini+0x9/0x10 [radeon]
[   52.268531]  [<ffffffffa0893bf1>] evergreen_fini+0x91/0xc0 [radeon]
[   52.268537]  [<ffffffffa08336ea>] radeon_device_fini+0x3a/0xf0 [radeon]
[   52.268543]  [<ffffffffa08353d1>] radeon_driver_unload_kms+0x41/0x70 [radeon]
[   52.268550]  [<ffffffffa016524e>] drm_put_dev+0x6e/0x210 [drm]
[   52.268555]  [<ffffffffa0832068>] radeon_pci_remove+0x18/0x20 [radeon]
[   52.268557]  [<ffffffff81385831>] pci_device_remove+0x41/0xc0
[   52.268561]  [<ffffffff8143bfd7>] __device_release_driver+0x77/0xe0
[   52.268563]  [<ffffffff8143c069>] device_release_driver+0x29/0x40
[   52.268566]  [<ffffffff8143ba71>] bus_remove_device+0xf1/0x140
[   52.268568]  [<ffffffff8143915d>] device_del+0x11d/0x1b0
[   52.268572]  [<ffffffff8138082c>] pci_stop_bus_device+0x9c/0xb0
[   52.268574]  [<ffffffff813807cb>] pci_stop_bus_device+0x3b/0xb0
[   52.268576]  [<ffffffff813a11e5>] ? acpiphp_disable_slot+0x35/0x140
[   52.268579]  [<ffffffff813807cb>] pci_stop_bus_device+0x3b/0xb0
[   52.268581]  [<ffffffff813807cb>] pci_stop_bus_device+0x3b/0xb0
[   52.268584]  [<ffffffff813807cb>] pci_stop_bus_device+0x3b/0xb0
[   52.268586]  [<ffffffff81380991>] pci_stop_and_remove_bus_device+0x11/0x20
[   52.268588]  [<ffffffff813a1236>] acpiphp_disable_slot+0x86/0x140
[   52.268591]  [<ffffffff813a1622>] _handle_hotplug_event_func+0x102/0x1e0
[   52.268594]  [<ffffffff8105c2c2>] process_one_work+0x1c2/0x560
[   52.268597]  [<ffffffff8105c257>] ? process_one_work+0x157/0x560
[   52.268599]  [<ffffffff8105d1d6>] worker_thread+0x116/0x370
[   52.268601]  [<ffffffff8105d0c0>] ? manage_workers.isra.20+0x2d0/0x2d0
[   52.268604]  [<ffffffff81063a36>] kthread+0xd6/0xe0
[   52.268606]  [<ffffffff816611ab>] ? _raw_spin_unlock_irq+0x2b/0x60
[   52.268609]  [<ffffffff81063960>] ? __init_kthread_worker+0x70/0x70
[   52.268612]  [<ffffffff8166856c>] ret_from_fork+0x7c/0xb0
[   52.268615]  [<ffffffff81063960>] ? __init_kthread_worker+0x70/0x70
[   52.268669] ---[ end trace 46b4e977738a3df6 ]---
[   52.269258] [TTM] Zone  kernel: Used memory at exit: 13 kiB
[   52.269266] [TTM] Zone   dma32: Used memory at exit: 9 kiB
[   52.269295] [drm] radeon: ttm finalized

But it looks like the removal actually succeeded.

[   52.273103] pci_bus 0000:0b: busn_res: [bus 0b] is released
[   52.273732] pci_bus 0000:0c: busn_res: [bus 0c] is released
[   52.273816] pci_bus 0000:16: busn_res: [bus 16] is released

Is the re-dock attempt included?  It doesn't seem to leave any trace ...

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
