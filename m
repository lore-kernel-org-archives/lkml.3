Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaDNQk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:40:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46001 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaDNQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:40:17 -0400
Date: Mon, 14 Apr 2014 09:40:10 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>
Subject: REGRESSION 3.14 i915 warning & mouse cursor vanishing
Message-ID: <20140414164010.GA1019@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was using my machine normally, then my mouse cursor vanished. After switching
to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
dmesg (below).

I have a few options specified on my command line related to i915, but these
worked fine through 3.13.9:

    i915.lvds_downclock=1 i915.i915_enable_rc6=7 i915.i915_enable_fbc=1

System is a Lenovo ThinkPad S1 Yoga.

lspci:

	$ sudo lspci -nn
	00:00.0 Host bridge [0600]: Intel Corporation Haswell-ULT DRAM Controller [8086:0a04] (rev 0b)
	00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT Integrated Graphics Controller [8086:0a16] (rev 0b)
	00:03.0 Audio device [0403]: Intel Corporation Device [8086:0a0c] (rev 0b)
	00:14.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB xHCI HC [8086:9c31] (rev 04)
	00:16.0 Communication controller [0780]: Intel Corporation Lynx Point-LP HECI #0 [8086:9c3a] (rev 04)
	00:1b.0 Audio device [0403]: Intel Corporation Lynx Point-LP HD Audio Controller [8086:9c20] (rev 04)
	00:1c.0 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 1 [8086:9c10] (rev e4)
	00:1c.2 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 3 [8086:9c14] (rev e4)
	00:1c.3 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 4 [8086:9c16] (rev e4)
	00:1d.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB EHCI #1 [8086:9c26] (rev 04)
	00:1f.0 ISA bridge [0601]: Intel Corporation Lynx Point-LP LPC Controller [8086:9c43] (rev 04)
	00:1f.2 SATA controller [0106]: Intel Corporation Lynx Point-LP SATA Controller 1 [AHCI mode] [8086:9c03] (rev 04)
	00:1f.3 SMBus [0c05]: Intel Corporation Lynx Point-LP SMBus Controller [8086:9c22] (rev 04)
	04:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [8086:08b2] (rev 73)
	05:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. Device [10ec:5227] (rev 01)


Let me know what other information would be helpful. I could do a bisection if
needed, but I'm hoping the stack traces below trigger an "aha" moment in somebody.

Here's the trace:

[ 1703.305960] ------------[ cut here ]------------
[ 1703.305982] WARNING: CPU: 2 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.305983] Device suspended
[ 1703.305984] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306011]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306028] CPU: 2 PID: 351 Comm: X Tainted: G         C   3.14.0-1-ec2 #1
[ 1703.306029] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306030]  0000000000000009 ffff88021f283d50 ffffffff814ea57f ffff88021f283d98
[ 1703.306032]  ffff88021f283d88 ffffffff810653dd ffff8800d2748000 000000000004400c
[ 1703.306034]  ffff8800d2748028 ffff8800d2748020 0000000074002529 ffff88021f283de8
[ 1703.306036] Call Trace:
[ 1703.306037]  <IRQ>  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306044]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306046]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306050]  [<ffffffff810a501d>] ? enqueue_task_fair+0x43d/0x550
[ 1703.306055]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306060]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306065]  [<ffffffffa00d3a3a>] i915_queue_hangcheck+0x129a/0x2f20 [i915]
[ 1703.306068]  [<ffffffff81099a5c>] ? try_to_wake_up+0x28c/0x2a0
[ 1703.306070]  [<ffffffff810c1572>] handle_irq_event_percpu+0x62/0x1f0
[ 1703.306072]  [<ffffffff810c173d>] handle_irq_event+0x3d/0x60
[ 1703.306074]  [<ffffffff810c44c8>] handle_edge_irq+0x108/0x140
[ 1703.306078]  [<ffffffff81016b3e>] handle_irq+0x1e/0x40
[ 1703.306081]  [<ffffffff814fba8f>] do_IRQ+0x4f/0xe0
[ 1703.306084]  [<ffffffff814f0b2d>] common_interrupt+0x6d/0x6d
[ 1703.306085]  <EOI>  [<ffffffff814ebe10>] ? arp_ignore+0x8c/0x8c
[ 1703.306089]  [<ffffffff810736ff>] ? msleep+0x2f/0x40
[ 1703.306092]  [<ffffffff812c9a32>] pci_raw_set_power_state+0x142/0x230
[ 1703.306095]  [<ffffffff812cbcd3>] pci_set_power_state+0xd3/0x150
[ 1703.306097]  [<ffffffff812cddba>] pci_restore_standard_config+0x3a/0x50
[ 1703.306099]  [<ffffffff812cde26>] pci_pm_runtime_resume+0x56/0xb0
[ 1703.306100]  [<ffffffff812cddd0>] ? pci_restore_standard_config+0x50/0x50
[ 1703.306103]  [<ffffffff8139090d>] __rpm_callback+0x8d/0xf0
[ 1703.306105]  [<ffffffff813909d5>] rpm_callback+0x65/0x90
[ 1703.306107]  [<ffffffff81390fa3>] rpm_resume+0x443/0x770
[ 1703.306109]  [<ffffffff8139253a>] __pm_runtime_resume+0x5a/0x80
[ 1703.306115]  [<ffffffffa0126049>] intel_runtime_pm_get+0x39/0x70 [i915]
[ 1703.306120]  [<ffffffffa00e3eb4>] i915_gem_evict_everything+0x15c4/0x2320 [i915]
[ 1703.306123]  [<ffffffff811a3f6c>] ? kmem_cache_alloc_trace+0x3c/0x240
[ 1703.306131]  [<ffffffffa007966a>] ? drm_vma_node_allow+0x2a/0xd0 [drm]
[ 1703.306137]  [<ffffffffa00e50bf>] ? i915_gem_execbuffer2+0x7f/0x1a00 [i915]
[ 1703.306141]  [<ffffffffa00e51f8>] i915_gem_execbuffer2+0x1b8/0x1a00 [i915]
[ 1703.306147]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1703.306150]  [<ffffffff814ecb25>] ? __schedule+0x665/0x8a0
[ 1703.306153]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1703.306155]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1703.306157]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1703.306159]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1703.306160] ---[ end trace b818a8455da5fdee ]---
[ 1703.306163] ------------[ cut here ]------------
[ 1703.306167] WARNING: CPU: 2 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.306168] Device suspended
[ 1703.306168] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306193]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306207] CPU: 2 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1703.306208] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306208]  0000000000000009 ffff88021f283d50 ffffffff814ea57f ffff88021f283d98
[ 1703.306210]  ffff88021f283d88 ffffffff810653dd ffff8800d2748000 00000000000c400c
[ 1703.306212]  ffff8800d2748028 ffff8800d2748020 0000000000000000 ffff88021f283de8
[ 1703.306214] Call Trace:
[ 1703.306215]  <IRQ>  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306218]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306220]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306223]  [<ffffffff810a501d>] ? enqueue_task_fair+0x43d/0x550
[ 1703.306227]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306232]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306236]  [<ffffffffa00d3a84>] i915_queue_hangcheck+0x12e4/0x2f20 [i915]
[ 1703.306238]  [<ffffffff81099a5c>] ? try_to_wake_up+0x28c/0x2a0
[ 1703.306240]  [<ffffffff810c1572>] handle_irq_event_percpu+0x62/0x1f0
[ 1703.306242]  [<ffffffff810c173d>] handle_irq_event+0x3d/0x60
[ 1703.306243]  [<ffffffff810c44c8>] handle_edge_irq+0x108/0x140
[ 1703.306245]  [<ffffffff81016b3e>] handle_irq+0x1e/0x40
[ 1703.306247]  [<ffffffff814fba8f>] do_IRQ+0x4f/0xe0
[ 1703.306250]  [<ffffffff814f0b2d>] common_interrupt+0x6d/0x6d
[ 1703.306251]  <EOI>  [<ffffffff814ebe10>] ? arp_ignore+0x8c/0x8c
[ 1703.306254]  [<ffffffff810736ff>] ? msleep+0x2f/0x40
[ 1703.306256]  [<ffffffff812c9a32>] pci_raw_set_power_state+0x142/0x230
[ 1703.306259]  [<ffffffff812cbcd3>] pci_set_power_state+0xd3/0x150
[ 1703.306261]  [<ffffffff812cddba>] pci_restore_standard_config+0x3a/0x50
[ 1703.306263]  [<ffffffff812cde26>] pci_pm_runtime_resume+0x56/0xb0
[ 1703.306264]  [<ffffffff812cddd0>] ? pci_restore_standard_config+0x50/0x50
[ 1703.306266]  [<ffffffff8139090d>] __rpm_callback+0x8d/0xf0
[ 1703.306268]  [<ffffffff813909d5>] rpm_callback+0x65/0x90
[ 1703.306270]  [<ffffffff81390fa3>] rpm_resume+0x443/0x770
[ 1703.306272]  [<ffffffff8139253a>] __pm_runtime_resume+0x5a/0x80
[ 1703.306278]  [<ffffffffa0126049>] intel_runtime_pm_get+0x39/0x70 [i915]
[ 1703.306283]  [<ffffffffa00e3eb4>] i915_gem_evict_everything+0x15c4/0x2320 [i915]
[ 1703.306285]  [<ffffffff811a3f6c>] ? kmem_cache_alloc_trace+0x3c/0x240
[ 1703.306292]  [<ffffffffa007966a>] ? drm_vma_node_allow+0x2a/0xd0 [drm]
[ 1703.306298]  [<ffffffffa00e50bf>] ? i915_gem_execbuffer2+0x7f/0x1a00 [i915]
[ 1703.306303]  [<ffffffffa00e51f8>] i915_gem_execbuffer2+0x1b8/0x1a00 [i915]
[ 1703.306308]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1703.306311]  [<ffffffff814ecb25>] ? __schedule+0x665/0x8a0
[ 1703.306313]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1703.306315]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1703.306318]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1703.306319]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1703.306320] ---[ end trace b818a8455da5fdef ]---
[ 1703.306326] ------------[ cut here ]------------
[ 1703.306330] WARNING: CPU: 2 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.306331] Device suspended
[ 1703.306331] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306355]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306369] CPU: 2 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1703.306370] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306371]  0000000000000009 ffff88021f283d50 ffffffff814ea57f ffff88021f283d98
[ 1703.306373]  ffff88021f283d88 ffffffff810653dd ffff8800d2748000 0000000000044008
[ 1703.306374]  ffff8800d2748028 ffff8800d2748020 0000000020000000 ffff88021f283de8
[ 1703.306376] Call Trace:
[ 1703.306377]  <IRQ>  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306380]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306382]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306387]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306392]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306396]  [<ffffffffa00d46f1>] i915_queue_hangcheck+0x1f51/0x2f20 [i915]
[ 1703.306399]  [<ffffffff81099a5c>] ? try_to_wake_up+0x28c/0x2a0
[ 1703.306400]  [<ffffffff810c1572>] handle_irq_event_percpu+0x62/0x1f0
[ 1703.306402]  [<ffffffff810c173d>] handle_irq_event+0x3d/0x60
[ 1703.306404]  [<ffffffff810c44c8>] handle_edge_irq+0x108/0x140
[ 1703.306406]  [<ffffffff81016b3e>] handle_irq+0x1e/0x40
[ 1703.306408]  [<ffffffff814fba8f>] do_IRQ+0x4f/0xe0
[ 1703.306410]  [<ffffffff814f0b2d>] common_interrupt+0x6d/0x6d
[ 1703.306411]  <EOI>  [<ffffffff814ebe10>] ? arp_ignore+0x8c/0x8c
[ 1703.306414]  [<ffffffff810736ff>] ? msleep+0x2f/0x40
[ 1703.306416]  [<ffffffff812c9a32>] pci_raw_set_power_state+0x142/0x230
[ 1703.306419]  [<ffffffff812cbcd3>] pci_set_power_state+0xd3/0x150
[ 1703.306421]  [<ffffffff812cddba>] pci_restore_standard_config+0x3a/0x50
[ 1703.306423]  [<ffffffff812cde26>] pci_pm_runtime_resume+0x56/0xb0
[ 1703.306424]  [<ffffffff812cddd0>] ? pci_restore_standard_config+0x50/0x50
[ 1703.306426]  [<ffffffff8139090d>] __rpm_callback+0x8d/0xf0
[ 1703.306428]  [<ffffffff813909d5>] rpm_callback+0x65/0x90
[ 1703.306430]  [<ffffffff81390fa3>] rpm_resume+0x443/0x770
[ 1703.306432]  [<ffffffff8139253a>] __pm_runtime_resume+0x5a/0x80
[ 1703.306438]  [<ffffffffa0126049>] intel_runtime_pm_get+0x39/0x70 [i915]
[ 1703.306443]  [<ffffffffa00e3eb4>] i915_gem_evict_everything+0x15c4/0x2320 [i915]
[ 1703.306445]  [<ffffffff811a3f6c>] ? kmem_cache_alloc_trace+0x3c/0x240
[ 1703.306452]  [<ffffffffa007966a>] ? drm_vma_node_allow+0x2a/0xd0 [drm]
[ 1703.306457]  [<ffffffffa00e50bf>] ? i915_gem_execbuffer2+0x7f/0x1a00 [i915]
[ 1703.306462]  [<ffffffffa00e51f8>] i915_gem_execbuffer2+0x1b8/0x1a00 [i915]
[ 1703.306467]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1703.306470]  [<ffffffff814ecb25>] ? __schedule+0x665/0x8a0
[ 1703.306472]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1703.306474]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1703.306476]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1703.306478]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1703.306479] ---[ end trace b818a8455da5fdf0 ]---
[ 1703.306481] ------------[ cut here ]------------
[ 1703.306484] WARNING: CPU: 2 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.306485] Device suspended
[ 1703.306486] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306510]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306523] CPU: 2 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1703.306524] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306525]  0000000000000009 ffff88021f283d50 ffffffff814ea57f ffff88021f283d98
[ 1703.306527]  ffff88021f283d88 ffffffff810653dd ffff8800d2748000 000000000004400c
[ 1703.306528]  ffff8800d2748028 ffff8800d2748020 00000000f4002529 ffff88021f283de8
[ 1703.306530] Call Trace:
[ 1703.306531]  <IRQ>  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306534]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306536]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306541]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306545]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306550]  [<ffffffffa00d4753>] i915_queue_hangcheck+0x1fb3/0x2f20 [i915]
[ 1703.306552]  [<ffffffff81099a5c>] ? try_to_wake_up+0x28c/0x2a0
[ 1703.306554]  [<ffffffff810c1572>] handle_irq_event_percpu+0x62/0x1f0
[ 1703.306555]  [<ffffffff810c173d>] handle_irq_event+0x3d/0x60
[ 1703.306557]  [<ffffffff810c44c8>] handle_edge_irq+0x108/0x140
[ 1703.306559]  [<ffffffff81016b3e>] handle_irq+0x1e/0x40
[ 1703.306561]  [<ffffffff814fba8f>] do_IRQ+0x4f/0xe0
[ 1703.306564]  [<ffffffff814f0b2d>] common_interrupt+0x6d/0x6d
[ 1703.306565]  <EOI>  [<ffffffff814ebe10>] ? arp_ignore+0x8c/0x8c
[ 1703.306567]  [<ffffffff810736ff>] ? msleep+0x2f/0x40
[ 1703.306569]  [<ffffffff812c9a32>] pci_raw_set_power_state+0x142/0x230
[ 1703.306572]  [<ffffffff812cbcd3>] pci_set_power_state+0xd3/0x150
[ 1703.306575]  [<ffffffff812cddba>] pci_restore_standard_config+0x3a/0x50
[ 1703.306576]  [<ffffffff812cde26>] pci_pm_runtime_resume+0x56/0xb0
[ 1703.306578]  [<ffffffff812cddd0>] ? pci_restore_standard_config+0x50/0x50
[ 1703.306580]  [<ffffffff8139090d>] __rpm_callback+0x8d/0xf0
[ 1703.306582]  [<ffffffff813909d5>] rpm_callback+0x65/0x90
[ 1703.306584]  [<ffffffff81390fa3>] rpm_resume+0x443/0x770
[ 1703.306586]  [<ffffffff8139253a>] __pm_runtime_resume+0x5a/0x80
[ 1703.306591]  [<ffffffffa0126049>] intel_runtime_pm_get+0x39/0x70 [i915]
[ 1703.306596]  [<ffffffffa00e3eb4>] i915_gem_evict_everything+0x15c4/0x2320 [i915]
[ 1703.306598]  [<ffffffff811a3f6c>] ? kmem_cache_alloc_trace+0x3c/0x240
[ 1703.306605]  [<ffffffffa007966a>] ? drm_vma_node_allow+0x2a/0xd0 [drm]
[ 1703.306610]  [<ffffffffa00e50bf>] ? i915_gem_execbuffer2+0x7f/0x1a00 [i915]
[ 1703.306615]  [<ffffffffa00e51f8>] i915_gem_execbuffer2+0x1b8/0x1a00 [i915]
[ 1703.306620]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1703.306623]  [<ffffffff814ecb25>] ? __schedule+0x665/0x8a0
[ 1703.306625]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1703.306627]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1703.306629]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1703.306631]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1703.306632] ---[ end trace b818a8455da5fdf1 ]---
[ 1703.306633] ------------[ cut here ]------------
[ 1703.306637] WARNING: CPU: 2 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.306638] Device suspended
[ 1703.306638] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306663]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306676] CPU: 2 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1703.306677] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306678]  0000000000000009 ffff88021f283d50 ffffffff814ea57f ffff88021f283d98
[ 1703.306680]  ffff88021f283d88 ffffffff810653dd ffff8800d2748000 00000000000c400c
[ 1703.306681]  ffff8800d2748028 ffff8800d2748020 00000000ffffffff ffff88021f283de8
[ 1703.306683] Call Trace:
[ 1703.306684]  <IRQ>  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306687]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306689]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306694]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306698]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306703]  [<ffffffffa00d4784>] i915_queue_hangcheck+0x1fe4/0x2f20 [i915]
[ 1703.306705]  [<ffffffff81099a5c>] ? try_to_wake_up+0x28c/0x2a0
[ 1703.306707]  [<ffffffff810c1572>] handle_irq_event_percpu+0x62/0x1f0
[ 1703.306708]  [<ffffffff810c173d>] handle_irq_event+0x3d/0x60
[ 1703.306710]  [<ffffffff810c44c8>] handle_edge_irq+0x108/0x140
[ 1703.306712]  [<ffffffff81016b3e>] handle_irq+0x1e/0x40
[ 1703.306714]  [<ffffffff814fba8f>] do_IRQ+0x4f/0xe0
[ 1703.306717]  [<ffffffff814f0b2d>] common_interrupt+0x6d/0x6d
[ 1703.306717]  <EOI>  [<ffffffff814ebe10>] ? arp_ignore+0x8c/0x8c
[ 1703.306720]  [<ffffffff810736ff>] ? msleep+0x2f/0x40
[ 1703.306722]  [<ffffffff812c9a32>] pci_raw_set_power_state+0x142/0x230
[ 1703.306725]  [<ffffffff812cbcd3>] pci_set_power_state+0xd3/0x150
[ 1703.306728]  [<ffffffff812cddba>] pci_restore_standard_config+0x3a/0x50
[ 1703.306729]  [<ffffffff812cde26>] pci_pm_runtime_resume+0x56/0xb0
[ 1703.306730]  [<ffffffff812cddd0>] ? pci_restore_standard_config+0x50/0x50
[ 1703.306733]  [<ffffffff8139090d>] __rpm_callback+0x8d/0xf0
[ 1703.306734]  [<ffffffff813909d5>] rpm_callback+0x65/0x90
[ 1703.306736]  [<ffffffff81390fa3>] rpm_resume+0x443/0x770
[ 1703.306739]  [<ffffffff8139253a>] __pm_runtime_resume+0x5a/0x80
[ 1703.306744]  [<ffffffffa0126049>] intel_runtime_pm_get+0x39/0x70 [i915]
[ 1703.306749]  [<ffffffffa00e3eb4>] i915_gem_evict_everything+0x15c4/0x2320 [i915]
[ 1703.306751]  [<ffffffff811a3f6c>] ? kmem_cache_alloc_trace+0x3c/0x240
[ 1703.306757]  [<ffffffffa007966a>] ? drm_vma_node_allow+0x2a/0xd0 [drm]
[ 1703.306763]  [<ffffffffa00e50bf>] ? i915_gem_execbuffer2+0x7f/0x1a00 [i915]
[ 1703.306767]  [<ffffffffa00e51f8>] i915_gem_execbuffer2+0x1b8/0x1a00 [i915]
[ 1703.306772]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1703.306776]  [<ffffffff814ecb25>] ? __schedule+0x665/0x8a0
[ 1703.306778]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1703.306780]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1703.306782]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1703.306783]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1703.306784] ---[ end trace b818a8455da5fdf2 ]---
[ 1703.306794] ------------[ cut here ]------------
[ 1703.306798] WARNING: CPU: 2 PID: 255 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1703.306798] Device suspended
[ 1703.306799] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1703.306823]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1703.306837] CPU: 2 PID: 255 Comm: kworker/2:3 Tainted: G        WC   3.14.0-1-ec2 #1
[ 1703.306838] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1703.306842] Workqueue: events intel_unregister_dsm_handler [i915]
[ 1703.306843]  0000000000000009 ffff880037e69c58 ffffffff814ea57f ffff880037e69ca0
[ 1703.306845]  ffff880037e69c90 ffffffff810653dd ffff8800d2748000 0000000000048254
[ 1703.306846]  ffff8800d2748028 ffff8800d2748020 0000000000000063 ffff880037e69cf0
[ 1703.306848] Call Trace:
[ 1703.306851]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1703.306852]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1703.306854]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1703.306857]  [<ffffffff8101ca4d>] ? native_sched_clock+0x7d/0xb0
[ 1703.306859]  [<ffffffff8101e202>] ? __switch_to_xtra+0x132/0x160
[ 1703.306863]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1703.306868]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1703.306874]  [<ffffffffa011bef1>] intel_attach_broadcast_rgb_property+0x241/0x1270 [i915]
[ 1703.306879]  [<ffffffffa011c349>] intel_attach_broadcast_rgb_property+0x699/0x1270 [i915]
[ 1703.306884]  [<ffffffffa011d420>] intel_panel_set_backlight+0xc0/0x160 [i915]
[ 1703.306889]  [<ffffffffa013bea4>] intel_unregister_dsm_handler+0x574/0x800 [i915]
[ 1703.306891]  [<ffffffff8108177d>] process_one_work+0x25d/0x450
[ 1703.306893]  [<ffffffff81082a76>] worker_thread+0x266/0x470
[ 1703.306895]  [<ffffffff81082810>] ? manage_workers.isra.18+0x3f0/0x3f0
[ 1703.306897]  [<ffffffff81089103>] kthread+0xe3/0xf0
[ 1703.306899]  [<ffffffff81089020>] ? kthread_stop+0xf0/0xf0
[ 1703.306901]  [<ffffffff814f96bc>] ret_from_fork+0x7c/0xb0
[ 1703.306903]  [<ffffffff81089020>] ? kthread_stop+0xf0/0xf0
[ 1703.306904] ---[ end trace b818a8455da5fdf3 ]---
[ 1795.274630] ------------[ cut here ]------------
[ 1795.274652] WARNING: CPU: 1 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1795.274654] Device suspended
[ 1795.274655] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1795.274681]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1795.274698] CPU: 1 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1795.274699] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1795.274700]  0000000000000009 ffff8800d2aa9bc0 ffffffff814ea57f ffff8800d2aa9c08
[ 1795.274702]  ffff8800d2aa9bf8 ffffffff810653dd ffff8800d2748000 0000000000070088
[ 1795.274704]  ffff8800d2748028 ffff8800d2748020 0000000002a202c7 ffff8800d2aa9c58
[ 1795.274706] Call Trace:
[ 1795.274711]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1795.274714]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1795.274715]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1795.274722]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1795.274726]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1795.274732]  [<ffffffffa00f0578>] i915_restore_display_reg+0x17b8/0x7ff0 [i915]
[ 1795.274737]  [<ffffffffa00f382a>] i915_restore_display_reg+0x4a6a/0x7ff0 [i915]
[ 1795.274745]  [<ffffffffa006bdd3>] drm_mode_set_config_internal+0x203/0x270 [drm]
[ 1795.274752]  [<ffffffffa006fa71>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 1795.274757]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1795.274762]  [<ffffffff811c1ea1>] ? do_readv_writev+0x1e1/0x200
[ 1795.274764]  [<ffffffff8108c7b0>] ? __hrtimer_start_range_ns+0x340/0x3b0
[ 1795.274767]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1795.274769]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1795.274772]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1795.274774]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1795.274775] ---[ end trace b818a8455da5fdf4 ]---
[ 1795.274778] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70088
[ 1795.274780] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70088
[ 1795.274782] ------------[ cut here ]------------
[ 1795.274787] WARNING: CPU: 1 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1795.274788] Device suspended
[ 1795.274789] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1795.274819]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1795.274833] CPU: 1 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1795.274834] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1795.274835]  0000000000000009 ffff8800d2aa9bc0 ffffffff814ea57f ffff8800d2aa9c08
[ 1795.274837]  ffff8800d2aa9bf8 ffffffff810653dd ffff8800d2748000 0000000000070080
[ 1795.274839]  ffff8800d2748028 ffff8800d2748020 00000000ffffbfff ffff8800d2aa9c58
[ 1795.274841] Call Trace:
[ 1795.274843]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1795.274845]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1795.274847]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1795.274852]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1795.274857]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1795.274863]  [<ffffffffa00f0624>] i915_restore_display_reg+0x1864/0x7ff0 [i915]
[ 1795.274867]  [<ffffffffa00f382a>] i915_restore_display_reg+0x4a6a/0x7ff0 [i915]
[ 1795.274874]  [<ffffffffa006bdd3>] drm_mode_set_config_internal+0x203/0x270 [drm]
[ 1795.274880]  [<ffffffffa006fa71>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 1795.274885]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1795.274889]  [<ffffffff811c1ea1>] ? do_readv_writev+0x1e1/0x200
[ 1795.274891]  [<ffffffff8108c7b0>] ? __hrtimer_start_range_ns+0x340/0x3b0
[ 1795.274894]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1795.274895]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1795.274898]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1795.274899]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1795.274901] ---[ end trace b818a8455da5fdf5 ]---
[ 1795.274902] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70080
[ 1795.274903] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70080
[ 1795.274905] ------------[ cut here ]------------
[ 1795.274909] WARNING: CPU: 1 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1795.274909] Device suspended
[ 1795.274910] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1795.274935]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1795.274952] CPU: 1 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1795.274953] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1795.274954]  0000000000000009 ffff8800d2aa9bc0 ffffffff814ea57f ffff8800d2aa9c08
[ 1795.274957]  ffff8800d2aa9bf8 ffffffff810653dd ffff8800d2748000 0000000000070084
[ 1795.274959]  ffff8800d2748028 ffff8800d2748020 00000000010a2000 ffff8800d2aa9c58
[ 1795.274961] Call Trace:
[ 1795.274964]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1795.274967]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1795.274969]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1795.274977]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1795.274981]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1795.274987]  [<ffffffffa00f0672>] i915_restore_display_reg+0x18b2/0x7ff0 [i915]
[ 1795.274992]  [<ffffffffa00f382a>] i915_restore_display_reg+0x4a6a/0x7ff0 [i915]
[ 1795.274998]  [<ffffffffa006bdd3>] drm_mode_set_config_internal+0x203/0x270 [drm]
[ 1795.275005]  [<ffffffffa006fa71>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 1795.275010]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1795.275014]  [<ffffffff811c1ea1>] ? do_readv_writev+0x1e1/0x200
[ 1795.275016]  [<ffffffff8108c7b0>] ? __hrtimer_start_range_ns+0x340/0x3b0
[ 1795.275018]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1795.275020]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1795.275022]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1795.275023]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1795.275025] ---[ end trace b818a8455da5fdf6 ]---
[ 1795.275026] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70084
[ 1795.275027] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70084
[ 1795.275624] ------------[ cut here ]------------
[ 1795.275636] WARNING: CPU: 1 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1795.275637] Device suspended
[ 1795.275638] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1795.275660]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1795.275674] CPU: 1 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1795.275675] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1795.275675]  0000000000000009 ffff8800d2aa9bf8 ffffffff814ea57f ffff8800d2aa9c40
[ 1795.275677]  ffff8800d2aa9c30 ffffffff810653dd ffff8800d2748000 0000000000070088
[ 1795.275679]  ffff8800d2748028 ffff8800d2748020 00000000029902c8 ffff8800d2aa9c90
[ 1795.275681] Call Trace:
[ 1795.275684]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1795.275685]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1795.275687]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1795.275692]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1795.275696]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1795.275701]  [<ffffffffa00f0578>] i915_restore_display_reg+0x17b8/0x7ff0 [i915]
[ 1795.275703]  [<ffffffff814ee902>] ? mutex_lock+0x12/0x2f
[ 1795.275708]  [<ffffffffa00f08a9>] i915_restore_display_reg+0x1ae9/0x7ff0 [i915]
[ 1795.275714]  [<ffffffffa006be0a>] drm_mode_set_config_internal+0x23a/0x270 [drm]
[ 1795.275720]  [<ffffffffa006fa71>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 1795.275725]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1795.275729]  [<ffffffff8108c7b0>] ? __hrtimer_start_range_ns+0x340/0x3b0
[ 1795.275731]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1795.275734]  [<ffffffff813e5ed5>] ? __sys_recvmsg+0x55/0x70
[ 1795.275736]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1795.275738]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1795.275739]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1795.275740] ---[ end trace b818a8455da5fdf7 ]---
[ 1795.275742] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70088
[ 1795.275743] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70088
[ 1795.275745] ------------[ cut here ]------------
[ 1795.275748] WARNING: CPU: 1 PID: 351 at drivers/gpu/drm/i915/intel_uncore.c:453 vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]()
[ 1795.275749] Device suspended
[ 1795.275750] Modules linked in: usb_storage fuse ctr ccm bnep tun wacom hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub joydev hid_multitouch usbhid btusb hid bluetooth 6lowpan_iphc arc4 nls_cp437 vfat fat iwlmvm snd_hda_codec_hdmi x86_pkg_temp_thermal mac80211 intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode snd_hda_codec_conexant snd_hda_codec_generic wmi iwlwifi psmouse serio_raw i2c_i801 cfg80211 thermal snd_hda_intel tpm_tis tpm snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi nvram battery ac snd_timer intel_smartconnect
[ 1795.275771]  evdev snd lpc_ich soundcore mfd_core processor usbip_host(C) usbip_core(C) efivarfs ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_common ahci libahci xhci_hcd libata ehci_pci ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 1795.275784] CPU: 1 PID: 351 Comm: X Tainted: G        WC   3.14.0-1-ec2 #1
[ 1795.275784] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET34WW (1.14 ) 02/26/2014
[ 1795.275785]  0000000000000009 ffff8800d2aa9bf8 ffffffff814ea57f ffff8800d2aa9c40
[ 1795.275787]  ffff8800d2aa9c30 ffffffff810653dd ffff8800d2748000 0000000000070084
[ 1795.275788]  ffff8800d2748028 ffff8800d2748020 00000000010a2000 ffff8800d2aa9c90
[ 1795.275790] Call Trace:
[ 1795.275792]  [<ffffffff814ea57f>] dump_stack+0x45/0x56
[ 1795.275794]  [<ffffffff810653dd>] warn_slowpath_common+0x7d/0xa0
[ 1795.275795]  [<ffffffff8106544c>] warn_slowpath_fmt+0x4c/0x50
[ 1795.275800]  [<ffffffffa0135d59>] vlv_flisdsi_write+0x1ea9/0x2ed0 [i915]
[ 1795.275804]  [<ffffffffa0136530>] vlv_flisdsi_write+0x2680/0x2ed0 [i915]
[ 1795.275809]  [<ffffffffa00f0672>] i915_restore_display_reg+0x18b2/0x7ff0 [i915]
[ 1795.275813]  [<ffffffffa00f08a9>] i915_restore_display_reg+0x1ae9/0x7ff0 [i915]
[ 1795.275819]  [<ffffffffa006be0a>] drm_mode_set_config_internal+0x23a/0x270 [drm]
[ 1795.275825]  [<ffffffffa006fa71>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 1795.275829]  [<ffffffffa0060a1a>] drm_ioctl+0x3ba/0x6c0 [drm]
[ 1795.275833]  [<ffffffff8108c7b0>] ? __hrtimer_start_range_ns+0x340/0x3b0
[ 1795.275835]  [<ffffffff811d3530>] do_vfs_ioctl+0x470/0x4b0
[ 1795.275836]  [<ffffffff813e5ed5>] ? __sys_recvmsg+0x55/0x70
[ 1795.275838]  [<ffffffff811d35c3>] SyS_ioctl+0x53/0x90
[ 1795.275840]  [<ffffffff810fd20d>] ? __audit_syscall_exit+0x26d/0x290
[ 1795.275842]  [<ffffffff814f976d>] system_call_fastpath+0x1a/0x1f
[ 1795.275843] ---[ end trace b818a8455da5fdf8 ]---
[ 1795.275844] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70084
[ 1795.275845] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70084

