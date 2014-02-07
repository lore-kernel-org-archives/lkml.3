Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBGPtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:49:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43529 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaBGPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:49:18 -0500
Date: Fri, 7 Feb 2014 16:49:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Imre Deak <imre.deak@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: intel_sdvo_init: trying to register non-static key
Message-ID: <20140207154911.GK24395@pd.tnic>
References: <20140207093205.GA24395@pd.tnic>
 <87d2iz18vi.fsf@intel.com>
 <1391771542.5669.6.camel@intelbox>
 <20140207112809.GG24395@pd.tnic>
 <20140207145149.GZ17001@phenom.ffwll.local>
 <1391787126.5669.11.camel@intelbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391787126.5669.11.camel@intelbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:32:06PM +0200, Imre Deak wrote:
> I just realized it's a different issue, since it's on the init path.
> Also we set the drm device as the parent for the sdvo i2c adapter as
> opposed to the dp i2c adapter where it's the connector device. So the
> above patch won't help in Borislav's case.

Yep, correct:

[    0.555355] Linux agpgart interface v0.103
[    0.555524] [drm] Initialized drm 1.1.0 20060810
[    0.559559] [drm] Memory usable by graphics device = 2048M
[    0.630197] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.630301] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.630384] [drm] Driver supports precise vblank timestamp query.
[    0.631116] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.653810] INFO: trying to register non-static key.
[    0.653896] the code is fine but needs lockdep annotation.
[    0.653974] turning off the locking correctness validator.
[    0.654057] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1+ #1
[    0.654136] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    0.654236]  ffff880213ca8000 ffff880213d01518 ffffffff81610028 ffffffff810ad3c1
[    0.654525]  ffff8800ca6f5ab8 ffff880213d01618 ffffffff8109e7c7 ffff880213ca8000
[    0.654819]  ffff880213ca8780 0000000000000000 0000000000000000 ffff880200000000
[    0.655108] Call Trace:
[    0.655186]  [<ffffffff81610028>] dump_stack+0x4f/0x7c
[    0.655270]  [<ffffffff810ad3c1>] ? console_unlock+0x2a1/0x450
[    0.655357]  [<ffffffff8109e7c7>] __lock_acquire+0x1b57/0x1d50
[    0.655441]  [<ffffffff8109f8b4>] ? mark_held_locks+0x74/0x140
[    0.655525]  [<ffffffff8109fbfe>] ? debug_check_no_locks_freed+0x8e/0x160
[    0.655612]  [<ffffffff8109ae23>] ? lockdep_init_map+0xb3/0x570
[    0.655696]  [<ffffffff8109fa9d>] ? trace_hardirqs_on_caller+0x11d/0x1e0
[    0.655784]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.655868]  [<ffffffff8109efd7>] lock_acquire+0x87/0x130
[    0.655953]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.656035]  [<ffffffff811fa8fe>] kernfs_deactivate+0x10e/0x150
[    0.656119]  [<ffffffff811fb0f8>] ? kernfs_addrm_finish+0x38/0x60
[    0.656206]  [<ffffffff811fb0f8>] kernfs_addrm_finish+0x38/0x60
[    0.656290]  [<ffffffff811fb358>] kernfs_remove_by_name_ns+0x58/0xb0
[    0.656375]  [<ffffffff811f8fd1>] remove_files.isra.1+0x41/0x80
[    0.656455]  [<ffffffff811f92d0>] sysfs_remove_group+0x50/0xb0
[    0.656541]  [<ffffffff811f936b>] sysfs_remove_groups+0x3b/0x60
[    0.656627]  [<ffffffff81417f4b>] device_remove_attrs+0x5b/0x80
[    0.656712]  [<ffffffff81418625>] device_del+0x125/0x1c0
[    0.656794]  [<ffffffff814186d6>] device_unregister+0x16/0x30
[    0.656876]  [<ffffffff814e8a5a>] i2c_del_adapter+0x1ba/0x270
[    0.656962]  [<ffffffff813ea986>] intel_sdvo_init+0x1f6/0x830
[    0.657048]  [<ffffffff8161c6c1>] ? preempt_count_sub+0xb1/0x100
[    0.657134]  [<ffffffff8161852b>] ? _raw_spin_unlock_irqrestore+0x4b/0x80
[    0.657220]  [<ffffffff814068a3>] ? gen6_read32+0x63/0x170
[    0.657305]  [<ffffffff813d260d>] intel_modeset_init+0xb3d/0x1010
[    0.657392]  [<ffffffff813f55b9>] ? intel_power_domains_init_hw+0xa9/0x110
[    0.657478]  [<ffffffff813978cf>] i915_driver_load+0xd5f/0xeb0
[    0.657565]  [<ffffffff8137d58a>] drm_dev_register+0x8a/0x190
[    0.657649]  [<ffffffff8137fc99>] drm_get_pci_dev+0xf9/0x230
[    0.657733]  [<ffffffff81393ccb>] i915_pci_probe+0x3b/0x60
[    0.657818]  [<ffffffff812d385e>] local_pci_probe+0x4e/0xa0
[    0.657899]  [<ffffffff81417719>] ? get_device+0x19/0x20
[    0.657982]  [<ffffffff812d4cb1>] pci_device_probe+0xe1/0x130
[    0.658067]  [<ffffffff8141c08b>] driver_probe_device+0x7b/0x240
[    0.658151]  [<ffffffff8141c2fb>] __driver_attach+0xab/0xb0
[    0.658234]  [<ffffffff8141c250>] ? driver_probe_device+0x240/0x240
[    0.658319]  [<ffffffff8141a3de>] bus_for_each_dev+0x5e/0x90
[    0.658403]  [<ffffffff8141bb9e>] driver_attach+0x1e/0x20
[    0.658487]  [<ffffffff8141b717>] bus_add_driver+0x117/0x230
[    0.658570]  [<ffffffff8141c9f4>] driver_register+0x64/0xf0
[    0.658650]  [<ffffffff812d3bf4>] __pci_register_driver+0x64/0x70
[    0.658738]  [<ffffffff81d34280>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
[    0.658839]  [<ffffffff8137fee5>] drm_pci_init+0x115/0x130
[    0.658919]  [<ffffffff81d34280>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
[    0.659021]  [<ffffffff81d342ea>] i915_init+0x6a/0x6c
[    0.659102]  [<ffffffff8100027e>] do_one_initcall+0x4e/0x170
[    0.659187]  [<ffffffff81070800>] ? parse_args+0xb0/0x360
[    0.659270]  [<ffffffff81cf9fbe>] kernel_init_freeable+0x106/0x19a
[    0.659355]  [<ffffffff81cf983b>] ? do_early_param+0x86/0x86
[    0.659440]  [<ffffffff81606c70>] ? rest_init+0xd0/0xd0
[    0.659521]  [<ffffffff81606c7e>] kernel_init+0xe/0x130
[    0.659604]  [<ffffffff81620d6c>] ret_from_fork+0x7c/0xb0
[    0.659685]  [<ffffffff81606c70>] ? rest_init+0xd0/0xd0
[    0.745837] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    0.756633] fbcon: inteldrmfb (fb0) is primary device


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
