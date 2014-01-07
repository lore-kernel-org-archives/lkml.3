Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaAGSvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:51:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56351 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753814AbaAGSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:50:53 -0500
Date: Tue, 7 Jan 2014 13:50:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: intel-gfx@lists.freedesktop.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Excessive WARN()s in Intel 915 driver
Message-ID: <Pine.LNX.4.44L0.1401071341180.1296-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The check_crtc_state() routine in drivers/gpu/drm/i915/intel_display.c
contains a whole bunch of WARN() statements (and so do other routines
in this source file, but this is the one I'm presently concerned
about).  Is it really necessary for these to be WARN?

I don't see how it does any good, every single time I boot my computer,
for the log to get filled with a register dump and stack backtrace:

[    2.149090] [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
[    2.149091] ------------[ cut here ]------------
[    2.149137] WARNING: CPU: 0 PID: 151 at drivers/gpu/drm/i915/intel_display.c:8334 check_crtc_state+0x5d8/0xb90 [i915]()
[    2.149138] pipe state doesn't match!
[    2.149145] Modules linked in: i915(+) i2c_algo_bit drm_kms_helper drm i2c_core video
[    2.149149] CPU: 0 PID: 151 Comm: systemd-udevd Not tainted 3.11.10-100.fc18.i686 #1
[    2.149151] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    2.149157]  00000000 00000000 f65cb50c c0992345 f65cb54c f65cb53c c0448f14 f80b1af2
[    2.149163]  f65cb568 00000097 f80a95a0 0000208e f8062cf8 f8062cf8 f666564c f6665000
[    2.149168]  00000004 f65cb554 c0448fd3 00000009 f65cb54c f80b1af2 f65cb568 f65cb7c0
[    2.149169] Call Trace:
[    2.149177]  [<c0992345>] dump_stack+0x41/0x52
[    2.149182]  [<c0448f14>] warn_slowpath_common+0x84/0xa0
[    2.149221]  [<f8062cf8>] ? check_crtc_state+0x5d8/0xb90 [i915]
[    2.149259]  [<f8062cf8>] ? check_crtc_state+0x5d8/0xb90 [i915]
[    2.149264]  [<c0448fd3>] warn_slowpath_fmt+0x33/0x40
[    2.149302]  [<f8062cf8>] check_crtc_state+0x5d8/0xb90 [i915]
[    2.149346]  [<f806d302>] intel_modeset_check_state+0x292/0x770 [i915]
[    2.149385]  [<f806d854>] intel_set_mode+0x34/0x40 [i915]
[    2.149424]  [<f806df5b>] intel_crtc_set_config+0x6fb/0x920 [i915]
[    2.149447]  [<f7d555eb>] drm_mode_set_config_internal+0x4b/0xc0 [drm]
[    2.149454]  [<f7d031fd>] drm_fb_helper_set_par+0x4d/0xc0 [drm_kms_helper]
[    2.149459]  [<c06e0f22>] fbcon_init+0x482/0x4d0
[    2.149465]  [<c073fc9e>] visual_init+0x9e/0x100
[    2.149469]  [<c0742051>] do_bind_con_driver+0x111/0x2d0
[    2.149474]  [<c05b6178>] ? sysfs_add_file+0x18/0x20
[    2.149477]  [<c05b6221>] ? sysfs_create_file+0x21/0x30
[    2.149482]  [<c074230d>] do_take_over_console+0xfd/0x1a0
[    2.149485]  [<c06df7af>] do_fbcon_takeover+0x5f/0xc0
[    2.149489]  [<c06e2e7f>] fbcon_event_notify+0x58f/0x690
[    2.149493]  [<c05b6135>] ? sysfs_add_file_mode+0x85/0xb0
[    2.149497]  [<c099bb63>] notifier_call_chain+0x43/0x60
[    2.149502]  [<c046b151>] __blocking_notifier_call_chain+0x41/0x80
[    2.149505]  [<c046b1af>] blocking_notifier_call_chain+0x1f/0x30
[    2.149508]  [<c06d4ce6>] fb_notifier_call_chain+0x16/0x20
[    2.149511]  [<c06d6d05>] register_framebuffer+0x1b5/0x2d0
[    2.149518]  [<f7d02f44>] drm_fb_helper_initial_config+0x2d4/0x470 [drm_kms_helper]
[    2.149523]  [<c0546b48>] ? __kmalloc+0x228/0x230
[    2.149555]  [<f803d293>] ? i915_write32+0xa3/0x140 [i915]
[    2.149587]  [<f803cd72>] ? i915_read32+0x52/0x110 [i915]
[    2.149631]  [<f808d96e>] intel_fbdev_initial_config+0x1e/0x20 [i915]
[    2.149663]  [<f8040cfb>] i915_driver_load+0xcbb/0xcf0 [i915]
[    2.149694]  [<f803e2a0>] ? i915_switcheroo_set_state+0xa0/0xa0 [i915]
[    2.149714]  [<f7d51553>] drm_get_pci_dev+0x133/0x250 [drm]
[    2.149746]  [<f803c43b>] i915_pci_probe+0x2b/0x60 [i915]
[    2.149752]  [<c06bc619>] pci_device_probe+0x79/0xb0
[    2.149756]  [<c076b5f9>] driver_probe_device+0x79/0x360
[    2.149760]  [<c06bc55e>] ? pci_match_device+0x9e/0xb0
[    2.149763]  [<c076b971>] __driver_attach+0x91/0xa0
[    2.149767]  [<c076b8e0>] ? driver_probe_device+0x360/0x360
[    2.149770]  [<c0769ab2>] bus_for_each_dev+0x42/0x80
[    2.149773]  [<c076affe>] driver_attach+0x1e/0x20
[    2.149776]  [<c076b8e0>] ? driver_probe_device+0x360/0x360
[    2.149779]  [<c076ac2c>] bus_add_driver+0xec/0x270
[    2.149783]  [<c06bc410>] ? pci_device_shutdown+0x60/0x60
[    2.149786]  [<c076bf6a>] driver_register+0x6a/0x160
[    2.149790]  [<c04a23b4>] ? smp_call_function_many+0x1f4/0x230
[    2.149793]  [<f7d0d000>] ? 0xf7d0cfff
[    2.149796]  [<f7d0d000>] ? 0xf7d0cfff
[    2.149800]  [<c06bb7f3>] __pci_register_driver+0x33/0x40
[    2.149816]  [<f7d5176d>] drm_pci_init+0xfd/0x110 [drm]
[    2.149819]  [<f7d0d000>] ? 0xf7d0cfff
[    2.149850]  [<f7d0d05e>] i915_init+0x5e/0x60 [i915]
[    2.149854]  [<c040045a>] do_one_initcall+0xda/0x1a0
[    2.149856]  [<f7d0d000>] ? 0xf7d0cfff
[    2.149861]  [<c04d5191>] ? tracepoint_update_probe_range+0x41/0x120
[    2.149863]  [<f7d0d000>] ? 0xf7d0cfff
[    2.149867]  [<c043d107>] ? set_memory_ro+0x37/0x40
[    2.149872]  [<c04a75d6>] load_module+0x1bb6/0x2470
[    2.149879]  [<c04a7f37>] SyS_init_module+0xa7/0x110
[    2.149883]  [<c051f06b>] ? vm_mmap_pgoff+0x8b/0xb0
[    2.149889]  [<c099f60d>] sysenter_do_call+0x12/0x28
[    2.149891] ---[ end trace d9dbcbe8160eac5c ]---

After all, it's not like there's anything I can do to fix the hardware,
is there?  And it doesn't look like the pipe state mismatch is going to
go away by itself.  Or is this a genuine, fixable, software bug?

In any case, wouldn't it be good enough for this message to be
dev_warn() instead of WARN()?

Alan Stern

