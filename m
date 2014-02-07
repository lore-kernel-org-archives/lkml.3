Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaBGJcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:32:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37982 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaBGJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:32:13 -0500
Date: Fri, 7 Feb 2014 10:32:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: intel-gfx@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: intel_sdvo_init: trying to register non-static key
Message-ID: <20140207093205.GA24395@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so I'm seeing this on rc1 + tip during boot:

[    0.558106] Linux agpgart interface v0.103
[    0.558283] [drm] Initialized drm 1.1.0 20060810
[    0.562280] [drm] Memory usable by graphics device = 2048M
[    0.632301] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.632401] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.632485] [drm] Driver supports precise vblank timestamp query.
[    0.633200] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.655917] INFO: trying to register non-static key.
[    0.656003] the code is fine but needs lockdep annotation.
[    0.656083] turning off the locking correctness validator.
[    0.656165] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1+ #1
[    0.656248] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    0.656348]  ffff880213ca8000 ffff880213d01518 ffffffff8160ffa8 ffffffff810ad3c1
[    0.656641]  ffff8800cabc7560 ffff880213d01618 ffffffff8109e7c7 ffff880213ca8000
[    0.656929]  ffff880213ca8780 0000000000000000 0000000000000000 ffff880200000000
[    0.657216] Call Trace:
[    0.657295]  [<ffffffff8160ffa8>] dump_stack+0x4f/0x7c
[    0.657378]  [<ffffffff810ad3c1>] ? console_unlock+0x2a1/0x450
[    0.657465]  [<ffffffff8109e7c7>] __lock_acquire+0x1b57/0x1d50
[    0.657551]  [<ffffffff8109f8b4>] ? mark_held_locks+0x74/0x140
[    0.657637]  [<ffffffff8109fbfe>] ? debug_check_no_locks_freed+0x8e/0x160
[    0.657724]  [<ffffffff8109ae23>] ? lockdep_init_map+0xb3/0x570
[    0.657809]  [<ffffffff8109fa9d>] ? trace_hardirqs_on_caller+0x11d/0x1e0
[    0.657897]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.657982]  [<ffffffff8109efd7>] lock_acquire+0x87/0x130
[    0.658062]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.658148]  [<ffffffff811fa8fe>] kernfs_deactivate+0x10e/0x150
[    0.658232]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.658318]  [<ffffffff811fb0f8>] kernfs_addrm_finish+0x38/0x60
[    0.658404]  [<ffffffff811fb358>] kernfs_remove_by_name_ns+0x58/0xb0
[    0.658490]  [<ffffffff811f8fd1>] remove_files.isra.1+0x41/0x80
[    0.658574]  [<ffffffff811f92d0>] sysfs_remove_group+0x50/0xb0
[    0.658659]  [<ffffffff811f936b>] sysfs_remove_groups+0x3b/0x60
[    0.658746]  [<ffffffff81417ecb>] device_remove_attrs+0x5b/0x80
[    0.658832]  [<ffffffff814185a5>] device_del+0x125/0x1c0
[    0.658915]  [<ffffffff81418656>] device_unregister+0x16/0x30
[    0.659000]  [<ffffffff814e89da>] i2c_del_adapter+0x1ba/0x270
[    0.659086]  [<ffffffff813ea916>] intel_sdvo_init+0x1f6/0x820
[    0.659172]  [<ffffffff8161c641>] ? preempt_count_sub+0xb1/0x100
[    0.659258]  [<ffffffff816184ab>] ? _raw_spin_unlock_irqrestore+0x4b/0x80
[    0.659347]  [<ffffffff81406823>] ? gen6_read32+0x63/0x170
[    0.659431]  [<ffffffff813d260d>] intel_modeset_init+0xb3d/0x1010
[    0.659519]  [<ffffffff813f5539>] ? intel_power_domains_init_hw+0xa9/0x110
[    0.659606]  [<ffffffff813978cf>] i915_driver_load+0xd5f/0xeb0
[    0.659692]  [<ffffffff8137d58a>] drm_dev_register+0x8a/0x190
[    0.659777]  [<ffffffff8137fc99>] drm_get_pci_dev+0xf9/0x230
[    0.659861]  [<ffffffff81393ccb>] i915_pci_probe+0x3b/0x60
[    0.659945]  [<ffffffff812d385e>] local_pci_probe+0x4e/0xa0
[    0.660029]  [<ffffffff81417699>] ? get_device+0x19/0x20
[    0.660110]  [<ffffffff812d4cb1>] pci_device_probe+0xe1/0x130
[    0.660194]  [<ffffffff8141c00b>] driver_probe_device+0x7b/0x240
[    0.660279]  [<ffffffff8141c27b>] __driver_attach+0xab/0xb0
[    0.660363]  [<ffffffff8141c1d0>] ? driver_probe_device+0x240/0x240
[    0.660448]  [<ffffffff8141a35e>] bus_for_each_dev+0x5e/0x90
[    0.660532]  [<ffffffff8141bb1e>] driver_attach+0x1e/0x20
[    0.660615]  [<ffffffff8141b697>] bus_add_driver+0x117/0x230
[    0.660698]  [<ffffffff8141c974>] driver_register+0x64/0xf0
[    0.660780]  [<ffffffff812d3bf4>] __pci_register_driver+0x64/0x70
[    0.660869]  [<ffffffff81d34280>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
[    0.660970]  [<ffffffff8137fee5>] drm_pci_init+0x115/0x130
[    0.661054]  [<ffffffff81d34280>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
[    0.661157]  [<ffffffff81d342ea>] i915_init+0x6a/0x6c
[    0.661241]  [<ffffffff8100027e>] do_one_initcall+0x4e/0x170
[    0.661328]  [<ffffffff81070800>] ? parse_args+0xb0/0x360
[    0.661412]  [<ffffffff81cf9fbe>] kernel_init_freeable+0x106/0x19a
[    0.661497]  [<ffffffff81cf983b>] ? do_early_param+0x86/0x86
[    0.661580]  [<ffffffff81606bf0>] ? rest_init+0xd0/0xd0
[    0.661663]  [<ffffffff81606bfe>] kernel_init+0xe/0x130
[    0.661746]  [<ffffffff81620cec>] ret_from_fork+0x7c/0xb0
[    0.661828]  [<ffffffff81606bf0>] ? rest_init+0xd0/0xd0
[    0.747947] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    0.758745] fbcon: inteldrmfb (fb0) is primary device

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
